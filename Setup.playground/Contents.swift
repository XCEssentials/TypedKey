import Cocoa

import RepoConfig
import Mustache

import XCEProjectGenerator

// MARK: - Global parameters

let swiftVersion = "4.0"
let tstSuffix = "Tst"

let company = (
    name: "XCEssentials",
    identifier: "io.XCEssentials",
    prefix: "XCE"
)

let product = (
    name: "TypedKey",
    summary: "Generic key for type safe access to values in any key-value storage.",
    type: Template.XCE.InfoPlist.Options.TargetType.framework
)

let moduleName = company.prefix + product.name

let podspecPath = moduleName + ".podspec"

let projectName = product.name

let licenseType = "MIT" // open-source

let author = (
    name: "Maxim Khatskevich",
    email: "maxim@khatskevi.ch"
)

let depTarget = Template.XCE
    .CocoaPods
    .Podfile
    .Options
    .DeploymentTarget
    .with(
        name: .iOS,
        minimumVersion: "8.0"
    )

let targetName = (
    main: product.name,
    tst: product.name + tstSuffix
)

let targetType = (
    main: product.type,
    tst: Template.XCE.InfoPlist.Options.TargetType.tests
)

let targetInfo = (
    main: "Info/" + targetName.main + ".plist",
    tst: "Info/" + targetName.tst + ".plist"
)

let bundleId = (
    main: company.identifier + "." + product.name,
    tst: company.identifier + "." + product.name + ".Tst"
)

let sourcesPath = (
    main: "Sources/" + targetName.main,
    tst: "Sources/" + targetName.tst
)

let structConfigPath = "project.yml"

let repo = (

    name: product.name,
    location: PathPrefix
        .iCloudDrive
        .appendingPathComponent("Dev/XCEssentials")
        .appendingPathComponent(product.name)
)

// MARK: - Actually write repo configuration files

try! Template.XCE.Gitignore
    .prepare()
    .render(.cocoaFramework)
    .write(at: repo.location)

try! Template.XCE.SwiftLint
    .prepare()
    .render(.recommended)
    .write(at: repo.location)

try! Template.XCE.Fastlane.Fastfile
    .prepare()
    .render(.framework(projectName: projectName))
    .write(at: repo.location)

try! Template.XCE.InfoPlist
    .prepare()
    .render(.with(targetType: targetType.main))
    .write(to: targetInfo.main, at: repo.location)

try! Template.XCE.InfoPlist
    .prepare()
    .render(.with(targetType: targetType.tst))
    .write(to: targetInfo.tst, at: repo.location)

try! Template.XCE.License.MIT
    .prepare()
    .render(.with(copyrightEntity: author.name))
    .write(at: repo.location)

try! Template.XCE.CocoaPods.Podspec
    .prepare()
    .render(.with(
        company: .with(
            name: company.name,
            prefix: company.prefix
        ),
        product: .with(
            name: product.name,
            summary: product.summary
        ),
        license: .with(
            type: licenseType
        ),
        author: .with(
            name: author.name,
            email: author.email
        ),
        deploymentTargets: [depTarget.name],
        subspecs: false
        )
    )
    .write(to: podspecPath, at: repo.location)

try! Template.XCE.CocoaPods.Podfile
    .prepare()
    .render(.with(
        workspaceName: product.name,
        globalEntries: [
            "use_frameworks!"
        ],
        sharedEntries: [
            "podspec"
        ],
        targets: [
            .target(
                named: targetName.main,
                projectName: projectName,
                deploymentTarget: depTarget,
                entries: []
            ),
            .target(
                named: targetName.tst,
                projectName: projectName,
                deploymentTarget: depTarget,
                entries: []
            )
        ]
        )
    )
    .write(at: repo.location)

//===

let specFormat = Spec.Format.v2_1_0

let project = Project(projectName) { project in

    project.configurations.all.override(

        "IPHONEOS_DEPLOYMENT_TARGET" <<< depTarget.minimumVersion,
        "SWIFT_VERSION" <<< swiftVersion,
        "VERSIONING_SYSTEM" <<< "apple-generic"
    )

    project.configurations.debug.override(

        "SWIFT_OPTIMIZATION_LEVEL" <<< "-Onone"
    )

    //---

    project.target(targetName.main, .iOS, .framework) { fwk in

        fwk.include(sourcesPath.main)

        //---

        fwk.configurations.all.override(

            "IPHONEOS_DEPLOYMENT_TARGET" <<< depTarget.minimumVersion,
            "PRODUCT_BUNDLE_IDENTIFIER" <<< bundleId.main,
            "INFOPLIST_FILE" <<< targetInfo.main,

            //--- iOS related:

            "SDKROOT" <<< "iphoneos",
            "TARGETED_DEVICE_FAMILY" <<< DeviceFamily.iOS.universal,

            //--- Framework related:

            "PRODUCT_NAME" <<< moduleName,
            "DEFINES_MODULE" <<< "NO",
            "SKIP_INSTALL" <<< "YES"
        )

        fwk.configurations.debug.override(

            "MTL_ENABLE_DEBUG_INFO" <<< true
        )

        //---

        fwk.unitTests(targetName.tst) { fwkTests in

            fwkTests.include(sourcesPath.tst)

            //---

            fwkTests.configurations.all.override(

                // very important for unit tests,
                // prevents the error when unit test do not start at all
                "LD_RUNPATH_SEARCH_PATHS" <<<
                "$(inherited) @executable_path/Frameworks @loader_path/Frameworks",

                "IPHONEOS_DEPLOYMENT_TARGET" <<< depTarget.minimumVersion,

                "PRODUCT_BUNDLE_IDENTIFIER" <<< bundleId.tst,
                "INFOPLIST_FILE" <<< targetInfo.tst,
                "FRAMEWORK_SEARCH_PATHS" <<< "$(inherited) $(BUILT_PRODUCTS_DIR)"
            )

            fwkTests.configurations.debug.override(

                "MTL_ENABLE_DEBUG_INFO" <<< true
            )
        }
    }
}

//===

try! Manager
    .prepareSpec(specFormat, for: project)
    .write(to: structConfigPath, at: repo.location)
