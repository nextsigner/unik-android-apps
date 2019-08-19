﻿import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import Qt.labs.folderlistmodel 2.2
import Qt.labs.settings 1.0
ApplicationWindow {
    id: app
    objectName: 'uaa'
    visibility:  "FullScreen"
    color: "#ff8833"
    property string moduleName: 'unik-android-apps'
    property int fs: width>height?app.width*0.03:app.width*0.06
    property color c1: "#1fbc05"
    property color c2: "#4fec35"
    property color c3: "white"
    property color c4: "black"
    property color c5: "#333333"

    property bool prima: false
    property int sec: 0
    property int ci: 0
    property var al: []
    property string ca: ''

    onClosing: {
        if(Qt.platform.os==='android'){
            //close.accepted = false;
        }
    }
    onCiChanged: app.ca=app.al[app.ci]
    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    Settings{
        id: appSettings
        category: 'conf-appsListLauncher'
        property string uApp
    }
    UnikSettings{
        id: unikSettings
        Component.onCompleted: {
            console.log('UnikColorTheme currentNumColor: '+unikSettings.currentNumColor)
            console.log('UnikColorTheme defaultColors: '+unikSettings.defaultColors)
            var nc=unikSettings.currentNumColor
            var cc1=unikSettings.defaultColors.split('|')
            var cc2=cc1[nc].split('-')
            app.c1=cc2[0]
            app.c2=cc2[1]
            app.c3=cc2[2]
            app.c4=cc2[3]
            app.visible=true
        }
    }
    FolderListModel{
        folder: 'file://./'
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
        id:r
        width: app.width-app.fs
        height:parent.height
        color: 'black'
        anchors.centerIn: parent
        Text {
            id: txtFlFolder
            text: "Folder: "+fl.folder
            color:'white'
            font.pixelSize: 12
        }
        ListView{
            id:lv
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: app.fs
            spacing: app.fs*0.25
            model:fl
            delegate: delegate
        }
        Component{
            id:delegate
            Rectangle{
                id:xItem
                width: txt.contentWidth+app.fs*2
                height: app.fs*2
                color: xItem.border.width!==0?app.c4:app.c2
                radius: app.fs*0.25
                border.width: fileName===app.ca?2:0
                border.color: fileName===app.ca?app.c2:app.c4
                anchors.horizontalCenter: parent.horizontalCenter
                visible:(''+fileName).indexOf('link')===0&&(''+fileName).indexOf('.ukl')>0
                onColorChanged: {
                    if(xItem.border.width!==0){
                        app.ca=app.al[index]
                        lv.currentIndex=index
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        run(fileName)
                    }
                    onDoubleClicked: {
                        unik.restartApp()
                    }
                }
                Text {
                    id: txt
                    text: (''+fileName).substring(5, (''+fileName).length-4)
                    font.pixelSize: app.fs
                    color:xItem.border.width!==0?app.c2:app.c4
                    anchors.centerIn: parent
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
                    tinit.restart()
                    //}
                    if(xItem.width>lv.width){
                        lv.width=xItem.width
                    }
                    var uklFileLocation=pws+'/'+fileName
                    msg1.visible=unik.fileExist(uklFileLocation)
                }
                Text {
                    id: msg1
                    text: 'Instalada'
                    font.pixelSize: app.fs*0.4
                    color:app.c1
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: app.fs*0.5
                }
            }
        }

    }
    Rectangle{
        id:tap
        anchors.fill: parent
        color: 'transparent'
        opacity:0.0
        Behavior on opacity{NumberAnimation{duration:500}
        }
    }

    Connections {id: con1; target: unik;onUkStdChanged:log.setTxtLog(''+unik.ukStd);}
    Connections {id: con2; target: unik;onUkStdChanged: log.setTxtLog(''+unik.ukStd); }

    Rectangle{
        id: xPb
        opacity: 0.0
        width: Screen.desktopAvailableWidth<Screen.desktopAvailableHeight ? Screen.desktopAvailableWidth*0.95 : Screen.desktopAvailableHeight*0.95
        height: titDownloadLog.contentHeight+log.contentHeight+pblaunch.height+app.fs
        anchors.centerIn: parent
        color: app.c1
        //radius: unikSettings.radius
        border.width: unikSettings.borderWidth
        border.color: app.c2
        clip:true
        Behavior on opacity{
            NumberAnimation{duration: 1000}
        }
        Column{
            id: colDownloadLog
            anchors.centerIn: parent
            spacing: app.fs*0.5
            Text{
                id: titDownloadLog
                color: app.c2
                width: app.width<app.height ? app.width*0.9 : app.height*0.9
                height: contentHeight
                wrapMode: Text.WordWrap
                font.pixelSize: app.fs
                horizontalAlignment: Text.AlignHCenter
                text: unikSettings.lang==='es'?'<b>Descargando '+app.ca+'</b>':'<b>Downloading '+app.ca+'</b>'
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text{
                id: log
                color: app.c2
                width: app.width<app.height ? app.width*0.9 : app.height*0.9
                height: contentHeight
                textFormat: Text.RichText
                wrapMode: Text.WordWrap
                font.pixelSize: app.fs*0.5
                horizontalAlignment: Text.AlignHCenter
                function setTxtLog(t){
                    var  d=(''+t).replace(/\n/g, ' ')
                    var p=true
                    if(d.indexOf('Socket')>=0){
                        p=false
                    }else if(d.indexOf('download git')>=0){
                        var m0=''+d.replace('download git ','')
                        var m1=m0.split(' ')
                        if(m1.length>1){
                            var m2=(''+m1[1]).replace('%','')
                            //unik.setFile('/home/nextsigner/nnn', ''+m2)
                            var m3=parseInt(m2.replace(/ /g,''))
                            pblaunch.width=pblaunch.parent.width/100*m3
                        }

                    }
                    if(p){
                        log.text=t
                    }
                }
            }

            Rectangle{
                id:pblaunch
                height: app.fs*0.5
                width: 0
                color: 'red'
            }
        }

        Boton{//Close
            id: btnCloseDownload
            w:app.fs
            h: w
            t: "\uf00d"
            d:unikSettings.lang==='es'?'Cerrar':'Close'
            b:app.c1
            c: app.c2
            anchors.right: parent.right
            anchors.rightMargin: app.fs*0.5
            anchors.top: parent.top
            anchors.topMargin: app.fs*0.5
            onClicking: {
                xPb.visible=false
            }
        }
    }


    Rectangle{
        id: xUWarnings
        width: app.width-app.fs
        height:parent.height
        color: app.c1
        border.width: unikSettings.borderWidth
        border.color: app.c2
        //visible: txtErrors.text!=='<b>Unik Errors</b>'
        property bool notShowAgain: false
        Connections {
            target: unik
            onUWarningChanged: {
                txtErrors.text+=''+unik.getUWarning()+'\n';
                if(!xUWarnings.notShowAgain){
                    xUWarnings.visible=true
                }
            }
        }
        Timer{
            running: true
            repeat: true
            interval: 3000
            onTriggered: xUWarnings.setUData()
        }
        Flickable{
            anchors.fill: parent
            contentWidth: txtErrors.contentWidth
            contentHeight: txtErrors.contentHeight
            Text {
                id: txtErrors
                text: '<b>Unik Errors</b>'
                font.pixelSize: app.fs
                color: app.c2
                width: xUWarnings.width*0.98
                wrapMode: Text.WordWrap
                anchors.top: parent.top
                anchors.topMargin: unikSettings?xUWarnings.width*0.02*unikSettings.zoom:xUWarnings.width*0.02
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Boton{//Close
            id: btnCloseXUWarning
            w:app.fs
            h: w
            t: "\uf00d"
            d:unikSettings.lang==='es'?'Cerrar':'Close'
            b:app.c1
            c: app.c2
            anchors.right: parent.right
            anchors.rightMargin: app.fs*0.5
            anchors.top: parent.top
            anchors.topMargin: app.fs*0.5
            onClicking: {
                xUWarnings.visible=false
            }
        }
        /*Boton{//Close for ever
            id: btnCloseXUWarningNotAgain
            w:app.fs
            h: w
            t: "\uf00d"
            d:unikSettings.lang==='es'?'Cerrar - No mostrar mas':'Close - Not Show Again'
            b:app.c1
            c: app.c2
            anchors.right: btnCloseXUWarning.right
            anchors.top: btnCloseXUWarning.bottom
            anchors.topMargin: app.fs*0.5
            onClicking: {
                xUWarnings.notShowAgain=true
                xUWarnings.visible=false
            }
        }*/
    }

    Timer{
        id: tinit
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
                app.close()
                engine.load('qrc:/appsListLaucher.qml')
            }else{
                //xP.visible=true
            }
            //flick.opacity=1.0
        }

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
            xPb.opacity=1.0
            var m0=params.split('-git=')
            var m1=m0[1].split(',')
            var m2=m1[0].split('/')
            var mn=m2[m2.length-1].replace(/.git/g, '')

            console.log('Launching from Unik Android Apps: '+m1[0])
            console.log('Launching from Unik Android Apps: '+m1[0])
            unik.cd(pws)
            unik.mkdir(pws+'/'+mn)
            var d = unik.downloadGit(m1[0], pws)
            unik.cd(pws+'/'+mn)
            engine.load(pws+'/'+mn+'/main.qml')
            app.close()
        }
        //unik.setUnikStartSettings(params)
        //unik.restartApp()
    }
}



