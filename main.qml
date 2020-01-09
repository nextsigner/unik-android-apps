import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import Qt.labs.folderlistmodel 2.2
import Qt.labs.settings 1.0
import "qrc:/"
ApplicationWindow {
    id: app
    objectName: 'uaa'
    visible: true
    visibility:  Qt.platform.os==='android'?"FullScreen":"Windowed"
    width: Qt.platform.os!=='android'?390:Screen.width
    height: Qt.platform.os!=='android'?960:Screen.height
    color: app.c1
    property string moduleName: 'unik-android-apps'
    property int fs: width>height?app.width*0.03:app.width*0.03*unikSettings.zoom
    property color c1//: "#1fbc05"
    property color c2//: "#4fec35"
    property color c3//: "white"
    property color c4//: "black"
    property color c5//: "#333333"

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
            //engine.load('qrc:/appsListLauncher.qml')
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
    UnikSettings{
        id: unikSettings
        url:moduleName//pws+'/'+moduleName+'/settings.json'
        //onCurrentNumColorChanged: appSettings.currentNumColors = currentNumColor
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
    Rectangle{
        id:xApp
        width: app.width<app.height?app.width:app.height
        height: app.width<app.height?app.height:app.width
        color: app.c1
        rotation: app.width<app.height?0:90
        property int mod: 0
        Rectangle{
            width: app.width
            height: app.height
            color: 'transparent'
            visible: xApp.mod===0
            Column{
                anchors.centerIn: parent
                spacing: app.fs
                UxBotCirc{
                    fontSize: app.fs*2
                    text: unikSettings.lang==='es'?'Instalar App':'Install App'
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: xApp.mod = 2
                }
                UxBotCirc{
                    fontSize: app.fs*2
                    text: unikSettings.lang==='es'?'Lista de Apps':'Apps List'
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: xApp.mod = 1
                }
            }
            UxBotCirc{
                text: '\uf1fc'
                fontSize: app.fs
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
                fontSize: app.fs
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
        }
        Item{
            id: xInstallApps
            width: app.width-app.fs*2
            height: app.height
            anchors.horizontalCenter: parent.horizontalCenter
            visible: xApp.mod===2
            Column{
                spacing: app.fs
                anchors.centerIn: parent
                UText {
                    id: labelInstallApp
                    text: unikSettings.lang==='es'?'<b>Instalar App</b>':'<b>Install App</b>'
                    font.pixelSize: app.fs*2
                }
                Item {
                    width: 1
                    height: app.fs*2
                }
                UText {
                    id: labelUrl
                    text: 'Url: '+botLoadUrls.currentUrlIndex
                    font.pixelSize: app.fs*2
                }
                TextField{
                    id: tiUrl
                    width: parent.width-app.fs
                    anchors.horizontalCenter: parent.horizontalCenter
                    Keys.onReturnPressed: {
                        if(text==='clean'){
                            appSettings.uArrayUrls = '|'
                            tiUrl.text = ''
                            return
                        }
                        updInstallApp.install()
                    }
                }
                Row{
                    spacing: app.fs
                    UxBotCirc{
                        id: botLoadUrls
                        text: '\uf021'
                        animationEnabled: false
                        blurEnabled: false
                        property int currentUrlIndex: 0
                        onClicked: {
                            let m0 = appSettings.uArrayUrls.split('|')
                            if(currentUrlIndex+1<m0.length-1){
                                currentUrlIndex++
                            }else{
                                currentUrlIndex=0
                            }
                            tiUrl.text = m0[currentUrlIndex]
                        }
                    }
                    UxBotCirc{
                        text: '\uf019'
                        animationEnabled: false
                        blurEnabled: false
                        onClicked: {
                           updInstallApp.install()
                        }
                    }
                }
                UProgressDownload{
                    id:updInstallApp
                    width: app.width
                    onDownloaded: {
                            let m0 = tiUrl.text.split('/')
                            let m1 =  m0[m0.length-1]
                            let m2 = m1.replace('.git', '').replace('.zip', '')
                            if(uDownloadRequestUrl.indexOf('http')>=0&&uDownloadRequestUrl.indexOf('.git')>0){
                                unik.setFile(pws+'/link_'+m2+'.ukl', '-git='+uDownloadRequestUrl)
                            }
                            infoText = '1:'+uDownloadRequestUrl+' 2:'+uDownloadRequestFolder+' 3:'+m2+' 4:'+pws
                            //xApp.mod=1
                            //xListApps.modView=2
                    }
                    function install(){
                        if(appSettings.uArrayUrls.indexOf(tiUrl.text)<0){
                            appSettings.uArrayUrls+=tiUrl.text+'|'
                        }
                        updInstallApp.infoText = unikSettings.lang==='es'?'Instalando '+tiUrl.text+'...':'Installing '+tiUrl.text+'...'
                        updInstallApp.download(tiUrl.text, pws)
                    }
                }
            }

            Item{
                width: app.width-app.fs
                height: app.fs*2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                //anchors.topMargin: app.fs
                UxBotCirc{
                    text: '\uf060'
                    animationEnabled: false
                    blurEnabled: false
                    onClicked: xApp.mod = 0
                }
            }
        }
        Item{
            id: xListApps
            width: app.width
            height: app.height
            visible: xApp.mod===1
            onVisibleChanged: if(visible)lv.focus=true
            property int modView: 0
            onModViewChanged: {
                for(let i=0;i<lv.count;i++){
                    if(lv.contentItem.children[i]){
                        console.log('lv'+i+': '+lv.contentItem.children[i].objectName)
                        if(xListApps.modView===1){
                            if(lv.contentItem.children[i].installed){
                                lv.contentItem.children[i].visible = true
                                lv.contentItem.children[i].height = app.fs*3+unikSettings.borderWidth*2
                            }else{
                                lv.contentItem.children[i].visible = false
                            }
                        }else  if(xListApps.modView===2){
                            if(!lv.contentItem.children[i].installed){
                                lv.contentItem.children[i].visible = (''+fl.get(i, 'fileName')).indexOf('link')===0&&(''+fl.get(i, 'fileName')).indexOf('.ukl')>0
                            }else{
                                lv.contentItem.children[i].visible = false
                            }
                        }else{
                            lv.contentItem.children[i].visible = (''+fl.get(i, 'fileName')).indexOf('link')===0&&(''+fl.get(i, 'fileName')).indexOf('.ukl')>0
                        }
                        if(lv.contentItem.children[i].visible){
                            lv.contentItem.children[i].height = app.fs*3+unikSettings.borderWidth*2
                        }else{
                            lv.contentItem.children[i].height = 0
                        }
                    }
                }
            }
            Column{
                anchors.centerIn: parent
                Item{
                    id: xBotListApps
                    width: app.width
                    height: app.fs*3
                    UxBotCirc{
                        text: '\uf060'
                        fontSize: app.fs
                        animationEnabled: false
                        blurEnabled: false
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left:  parent.left
                        anchors.leftMargin: app.fs
                        onClicked: xApp.mod = 0
                    }
                    UxBotCirc{
                        text: xListApps.modView===0?'\uf069':xListApps.modView===1?'\uf00c':'\uf019'
                        fontSize: app.fs
                        animationEnabled: false
                        blurEnabled: false
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right:  parent.right
                        anchors.rightMargin: app.fs
                        onClicked: {
                            if(xListApps.modView===0){
                                xListApps.modView=1
                            }else  if(xListApps.modView===1){
                                xListApps.modView=2
                            }else{
                                xListApps.modView=0
                            }
                        }
                    }

                }
                ListView{
                    id:lv
                    width: app.width-app.fs
                    height: app.height-app.fs*5
                    anchors.horizontalCenter: parent.horizontalCenter
                    //anchors.top: parent.top
                    //anchors.topMargin: app.fs*3
                    spacing: app.fs
                    model:fl
                    delegate: delegate
                    Component{
                        id:delegate
                        UxBotRect{
                            id:xItem
                            objectName: 'aaa'+index
                            height: visible?app.fs*3+unikSettings.borderWidth*2:0
                            visible:(''+fileName).indexOf('link')===0&&(''+fileName).indexOf('.ukl')>0//&&(xListApps.modView===0||xListApps.modView===1&&msg1.visible)
                            property bool installed: false
                            text: (''+fileName).substring(5, (''+fileName).length-4)
                            anchors.horizontalCenter: parent.horizontalCenter
                            animationEnabled: false
                            glowEnabled: false
                            onClicked: {
                                app.ca=app.al[index]
                                lv.currentIndex=index
                                run(fileName)
                            }
                            Component.onCompleted: {
                                app.al.push(fileName)
                                if((''+fileName).indexOf('link')===0&&(''+fileName).indexOf('.json')>0&&!app.prima){
                                    app.ca=app.al[index]
                                    app.prima=true
                                    tap.color='black'
                                    xP.visible=true
                                }
                                //if( tlaunch.enabled){
                                timerInit.restart()
                                //}
                                if(xItem.width>lv.width){
                                    lv.width=xItem.width
                                }
                                var uklFileLocation=pws+'/'+fileName
                                xItem.installed=unik.fileExist(uklFileLocation)
                            }
                        }

                        //                        Rectangle{
                        //                            id:xItem
                        //                            width: txt.contentWidth+app.fs*2
                        //                            height: visible?app.fs*2:0
                        //                            color: xItem.border.width!==0?app.c1:app.c2
                        //                            radius: app.fs*0.25
                        //                            border.width: fileName===app.ca?2:0
                        //                            border.color: fileName===app.ca?app.c2:app.c1
                        //                            anchors.horizontalCenter: parent.horizontalCenter
                        //                            visible:(''+fileName).indexOf('link')===0&&(''+fileName).indexOf('.ukl')>0//&&(xListApps.modView===0||xListApps.modView===1&&msg1.visible)
                        //                            property bool installed: false
                        //                            onColorChanged: {
                        //                                if(xItem.border.width!==0){
                        //                                    app.ca=app.al[index]
                        //                                    lv.currentIndex=index
                        //                                }
                        //                            }
                        //                            MouseArea{
                        //                                anchors.fill: parent
                        //                                onClicked: {
                        //                                    run(fileName)
                        //                                }
                        //                                onDoubleClicked: {
                        //                                    unik.restartApp()
                        //                                }
                        //                            }
                        //                            Text {
                        //                                id: txt
                        //                                text: (''+fileName).substring(5, (''+fileName).length-4)
                        //                                font.pixelSize: app.fs
                        //                                color:xItem.border.width!==0?app.c2:app.c1
                        //                                anchors.centerIn: parent
                        //                            }
                        //                            Component.onCompleted: {
                        //                                app.al.push(fileName)
                        //                                if((''+fileName).indexOf('link')===0&&(''+fileName).indexOf('.json')>0&&!app.prima){
                        //                                    app.ca=app.al[index]
                        //                                    app.prima=true
                        //                                    tap.color='black'
                        //                                    xP.visible=true
                        //                                }
                        //                                //if( tlaunch.enabled){
                        //                                timerInit.restart()
                        //                                //}
                        //                                if(xItem.width>lv.width){
                        //                                    lv.width=xItem.width
                        //                                }
                        //                                var uklFileLocation=pws+'/'+fileName
                        //                                xItem.installed=unik.fileExist(uklFileLocation)
                        //                                //msg1.visible=xItem.installed
                        //                            }
                        //                        }
                    }
                }
            }
            UProgressDownload{
                id:updInstallListApp
                width: parent.width
                property string uModuleName
                onDownloaded: {
                    engine.load(pws+'/'+uModuleName+'/main.qml')
                    app.close()
                }
            }
        }

    }
//    UText {
//        text: 'FS: '+appSettings.currentNumColors//app.fs+' W: '+app.width+' H: '+app.height
//        font.pixelSize: app.fs*2
//        Rectangle{
//            width: parent.width
//            height: app.fs*2
//            anchors.centerIn: parent
//            z:parent.z-1
//        }
//    }
    UWarnings{}
    Rectangle{
        id:tap
        anchors.fill: parent
        color: 'transparent'
        opacity:0.0
        Behavior on opacity{NumberAnimation{duration:500}
        }
    }

    //Connections {id: con1; target: unik;onUkStdChanged:log.setTxtLog(''+unik.ukStd);}
    //Connections {id: con2; target: unik;onUkStdChanged: log.setTxtLog(''+unik.ukStd); }


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
                    //app.visible=true
                    vacio=false
                }
                if(appSettings.uApp===app.al[i]){
                    app.ca=app.al[i]
                }
            }
            if(vacio){
                //app.close()
                //engine.load('qrc:/appsListLauncher.qml')
            }else{
                //xP.visible=true
            }
            //flick.opacity=1.0
        }

    }

    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }

    Component.onCompleted: {
        unikSettings.currentNumColor = appSettings.currentNumColors
    }

    function updateUS(){
        var nc=unikSettings.currentNumColor
        var cc1=unikSettings.defaultColors.split('|')
        var cc2=cc1[nc].split('-')
        app.c1=cc2[0]
        app.c2=cc2[1]
        app.c3=cc2[2]
        app.c4=cc2[3]

        unikSettings.zoom=1.4
        unikSettings.borderWidth=app.fs*0.5
        unikSettings.padding=0.5

        app.visible=true
    }

    function run(ukl){
        var urlGit=(''+unik.getFile(ukl)).replace(/\n/g, '')
        var params=urlGit
        var m0=urlGit.split('/')
        var s1=(''+m0[m0.length-1]).replace('.git', '')
        var uklFileLocation=pws+'/link_'+s1+'.ukl'
        var uklData=''+urlGit
        uklData+=' -folder='+pws+'/'+s1+' \n'
        unik.setFile(uklFileLocation, uklData)
        params+=', -folder='+pws+'/'+s1
        //params+=', -dir='+pws+'/'+s1

        //downloadGit(QByteArray url, QByteArray localFolder)
        if(params.indexOf('-git=')>=0&&params.indexOf('-git=')!==params.length-1&&params.length>5){
            //xPb.opacity=1.0
            var m0=params.split('-git=')
            var m1=m0[1].split(',')
            var m2=m1[0].split('/')
            var mn=m2[m2.length-1].replace(/.git/g, '')

            console.log('Launching from Unik Android Apps: '+m1[0])
            console.log('Launching from Unik Android Apps: '+m1[0])
            unik.cd(pws)
            unik.mkdir(pws+'/'+mn)
            //var d = unik.downloadGit(m1[0], pws)
            updInstallListApp.download(m1[0], pws)
            unik.cd(pws+'/'+mn)
            updInstallListApp.uModuleName = mn
            //engine.load(pws+'/'+mn+'/main.qml')
            //app.close()
        }
        //unik.setUnikStartSettings(params)
        //unik.restartApp()
    }
}



