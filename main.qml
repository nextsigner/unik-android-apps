import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import Qt.labs.folderlistmodel 2.2
import Qt.labs.settings 1.0
//import "qrc:/"

ApplicationWindow {
    id: app
    objectName: 'uaa'
    visible: true
    visibility:  Qt.platform.os==='android'?"FullScreen":"Windowed"
    width: Qt.platform.os!=='android'?390:Screen.width//Screen.width<Screen.height?Screen.width:Screen.height
    height: Qt.platform.os!=='android'?960:Screen.height//Screen.width<Screen.height?Screen.height:Screen.width
    color: app.c1
    property string moduleName: 'unik-android-apps'
    property int fs: Qt.platform.os==='android'?(width>height?app.width*0.02*unikSettings.zoom:app.height*0.02*unikSettings.zoom):width*0.03*unikSettings.zoom
    property color c1
    property color c2
    property color c3
    property color c4
    property color c5

    property bool prima: false
    property int sec: 0
    property int ci: 0
    property var al: []
    property string ca: ''

    onClosing: {
        if(Qt.platform.os==='android'){
            close.accepted = true;
            if(xApp.mod===0){
                Qt.quit()
            }
        }else{
            close.accepted = true;
            Qt.quit()
        }
    }
    onCiChanged: app.ca=app.al[app.ci]
    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    Settings{
        id: appSettings
        category: 'conf-android-apps'
        property string uApp
        property int currentNumColors
        property string uArrayUrls
    }
    USettings{
        id: unikSettings
        url:pws+'/'+moduleName+'/'+moduleName+'.json'
        Component.onCompleted: {
            currentNumColor = appSettings.currentNumColors
            updateUS()
        }
    }
    FolderListModel{
        folder: Qt.platform.os!=='android'?'file:./':'file://'+unik.currentFolderPath()
        id:fl
        showDirs:  false
        showDotAndDotDot: false
        showHidden: false
        showOnlyReadable: true
        sortField: FolderListModel.Name
        nameFilters: "*.ukl"
        property int f: 0
        onCountChanged: {
            console.log('File: '+fl.get(f,"fileName"))
            f++
        }
    }
    FolderListModel{
        folder: Qt.platform.os!=='android'?'file:./':'file://'+unik.currentFolderPath().replace('/unik-android-apps', '')
        id:flFolders
        showFiles: false
        showDirs:  true
        showDotAndDotDot: false
        showHidden: false
        showOnlyReadable: true
        sortField: FolderListModel.Name
        //nameFilters: "*.ukl"
        property int f: 0
        onCountChanged: {
            console.log('File: '+fl.get(f,"fileName"))
            f++
        }
    }
    Rectangle{
        id:xApp
        width: Qt.platform.os==='android'?(Screen.width<Screen.height?app.width:app.height):app.width
        height: Qt.platform.os==='android'?(Screen.width<Screen.height?app.height:app.width):app.height
        color: app.c1
        rotation: Qt.platform.os==='android'?(Screen.width<Screen.height?0:90):0
        anchors.centerIn: parent
        property int mod: 0
        Rectangle{
            anchors.fill: parent
            color: 'transparent'
            visible: xApp.mod===0
            Column{
                anchors.centerIn: parent
                spacing: app.fs
                UxBotCirc{
                    width: app.fs*25
                    fontSize: app.fs*3
                    text: unikSettings.lang==='es'?'Instalar App':'Install App'
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: xApp.mod = 2
                }
                UxBotCirc{
                    width: app.fs*25
                    fontSize: app.fs*3
                    text: unikSettings.lang==='es'?'Lista de Apps':'Apps List'
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: xApp.mod = 1
                }
            }
            UxBotCirc{
                text: '\uf1fc'//+unikSettings.currentNumColor
                animationEnabled: false
                blurEnabled: false
                anchors.left: parent.left
                anchors.leftMargin: app.fs*0.5
                anchors.top: parent.top
                anchors.topMargin: app.fs*0.5
                onClicked: {
                    var cc=unikSettings.defaultColors.split('|').length
                    if(unikSettings.currentNumColor<cc-1){
                        unikSettings.currentNumColor++
                    }else{
                        unikSettings.currentNumColor=0
                    }
                    appSettings.currentNumColors = unikSettings.currentNumColor
                    updateUS()
                }
            }
            UxBotCirc{
                text: '\uf011'
                animationEnabled: false
                blurEnabled: false
                anchors.right: parent.right
                anchors.rightMargin: app.fs*0.5
                anchors.top: parent.top
                anchors.topMargin: app.fs*0.5
                onClicked: {
                    Qt.quit()
                }
            }
            UxBotCirc{
                text: '<b>+</b>'
                animationEnabled: false
                blurEnabled: false
                anchors.bottom: parent.bottom
                anchors.bottomMargin: app.fs*0.5
                anchors.right: parent.right
                anchors.rightMargin: app.fs*0.5
                onClicked: {
                    unik.restartApp()
                }
            }
            UxBotCirc{
                text: '\uf021'
                animationEnabled: false
                blurEnabled: false
                anchors.bottom: parent.bottom
                anchors.bottomMargin: app.fs*0.5
                anchors.left:  parent.left
                anchors.leftMargin: app.fs*0.5
                onClicked: {
                    upd.infoText = unikSettings.lang==='es'?'<b>Actualización: </b>Se ha iniciado la actualización\nde <b>Unik Android Apps</b>':'<b>Update: </b> Updating <b>Unik Android Apps</b>'
                    upd.download('https://github.com/nextsigner/'+moduleName+'.git', pws)
                }
            }
        }
        UProgressDownload{
            id:upd
            width: app.width
            onDownloaded: {
                unik.setUnikStartSettings('-folder='+unik.currentFolderPath())
                unik.restartApp()
            }
        }
        XInstallApps{anchors.centerIn: parent}
        XListApps{anchors.centerIn: parent}
    }
    UWarnings{showEnabled: false}
    ULogView{id:uLogView}
    /*UText{
        id: devInfo
        text:  ''+flFolders.folder
        font.pixelSize: 20
        color: 'red'
        width: Screen.width
        wrapMode: Text.WrapAnywhere
    }*/
    Rectangle{
        id:tap
        anchors.fill: parent
        color: 'transparent'
        opacity:0.0
        Behavior on opacity{NumberAnimation{duration:500}
        }
    }
    Timer{
        id: timerInit
        running: true
        repeat: false
        interval: 1000
        onTriggered: {
            tap.opacity=0.0
            if(appSettings.uApp===''&&app.al.length>0){
                appSettings.uApp=app.al[0]
            }
            var vacio=true
            for(var i=0;i<app.al.length;i++){
                if((''+app.al[i]).indexOf('.ukl')>0){
                    vacio=false
                }
                if(appSettings.uApp===app.al[i]){
                    app.ca=app.al[i]
                }
            }
            if(vacio){
                //engine.load('qrc:/main.qml')
            }
        }
    }

    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }

    Component.onCompleted: {
        unikSettings.currentNumColor = appSettings.currentNumColors
        let cfgLocation = pws+'/cfg.json'
        let cfgData = '-folder='+pws+'/unik-android-apps'
         //NO HABILITAR NI ESCRIBIR CFJ.JSON PORQUE FALLA!
        //unik.setFile(cfgLocation, cfgData)
    }

    function updateUS(){
        var nc=unikSettings.currentNumColor
        var cc1=unikSettings.defaultColors.split('|')
        var cc2=cc1[nc].split('-')
        app.c1=cc2[0]
        app.c2=cc2[1]
        app.c3=cc2[2]
        app.c4=cc2[3]

        //unikSettings.zoom=1.4
        //unikSettings.borderWidth=app.fs*0.5
        //unikSettings.padding=0.5

        app.visible=true
    }

    function run(ukl){
        var urlGit=(''+unik.getFile(ukl)).replace(/\n/g, '')
        var params=urlGit
        var mug=urlGit.split('/')
        var s1=(''+mug[mug.length-1]).replace('.git', '')
        var uklFileLocation=pws+'/link_'+s1+'.ukl'
        var uklData=''+urlGit
        uklData+=' -folder='+pws+'/'+s1+' \n'
        unik.setFile(uklFileLocation, uklData)
        params+=', -folder='+pws+'/'+s1

        if(params.indexOf('-git=')>=0&&params.indexOf('-git=')!==params.length-1&&params.length>5){
            let m0=params.split('-git=')
            let m1=m0[1].split(',')
            let m2=m1[0].split('/')
            let mn=m2[m2.length-1].replace(/.git/g, '')

            console.log('Launching from Unik Android Apps: '+m1[0])
            console.log('Launching from Unik Android Apps: '+m1[0])

            unik.cd(pws)
            unik.mkdir(pws+'/'+mn)
            updInstallListApp.download(m1[0], pws)
            unik.cd(pws+'/'+mn)
            updInstallListApp.uModuleName = mn
        }
    }
}
