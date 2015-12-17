"
" Creates sensible default classpath variables for Syntastic and JavaComplete2
"

function GatherClassPath()
    let classPath = []
    let androidSdkHome = $ANDROID_HOME
    call add(classPath, "src")
    call add(classPath, "test")
    let classPath = classPath + glob("lib/**/*.jar", 1, 1)
    call add(classPath, "src/main/java")
    call add(classPath, androidSdkHome . '/' . "add-ons/addon-google_apis-google-23/libs/effects.jar")
    call add(classPath, androidSdkHome . '/' . "add-ons/addon-google_apis-google-23/libs/maps.jar")
    call add(classPath, androidSdkHome . '/' . "add-ons/addon-google_apis-google-23/libs/usb.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/annotations/android-support-annotations.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/customtabs/libs/android-support-customtabs.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/design/libs/android-support-design.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/multidex/instrumentation/libs/android-support-multidex-instrumentation.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/multidex/instrumentation/libs/android-support-multidex.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/multidex/library/libs/android-support-multidex.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/percent/libs/android-support-percent.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/recommendation/libs/android-support-recommendation.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/v4/android-support-v4.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/v7/appcompat/libs/android-support-v4.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/v7/appcompat/libs/android-support-v7-appcompat.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/v7/cardview/libs/android-support-v7-cardview.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/v7/gridlayout/libs/android-support-v7-gridlayout.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/v7/mediarouter/libs/android-support-v7-mediarouter.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/v7/palette/libs/android-support-v7-palette.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/v7/preference/libs/android-support-v7-preference.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/v7/recyclerview/libs/android-support-v7-recyclerview.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/v13/android-support-v13.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/v14/preference/libs/android-support-v14-preference.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/v17/leanback/libs/android-support-v17-leanback.jar")
    call add(classPath, androidSdkHome . '/' . "extras/android/support/v17/preference-leanback/libs/android-support-v17-preference-leanback.jar")
    "call add(classPath, androidSdkHome . '/' . "platforms/android-17/android.jar")
    call add(classPath, androidSdkHome . '/' . "platforms/android-23/android.jar")

    " Generated resources
    let rPaths = []
    call add(rPaths, "build/generated/source/r/debug")
    let classPath += rPaths

    " Stringify
    let classPathStr = join(classPath, ";")
    return classPathStr
endfunction

let classPath = g:GatherClassPath()
let g:JavaComplete_LibsPath = g:classPath
let g:JavaComplete_SourcesPath = "src/main/java"
let g:syntastic_java_javac_classpath = g:classPath

