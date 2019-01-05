import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.2
import Qt.labs.settings 1.0
ApplicationWindow {
    id: app
    objectName: 'uaa'
    visibility:  "FullScreen"
    color: "black"
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
            close.accepted = false;
        }
    }
    onCiChanged: app.ca=app.al[app.ci]
    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    Settings{
        id: appSettings
        category: 'conf-appsListLauncher'
        property string uApp
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
                }
                Text {
                    text: '\uf061'
                    font.family: "FontAwesome"
                    font.pixelSize: app.fs
                    color:app.c2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.left
                    anchors.rightMargin: app.fs*0.5
                    visible: xItem.border.width!==0
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
    Text{
        id:txta
        font.pixelSize: app.fs
        anchors.centerIn: parent
        width: r.width*0.8
        wrapMode: Text.WrapAnywhere
        color: 'yellow'
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
                xP.visible=true
            }
            flick.opacity=1.0
        }

    }
    function run(ukl){
        var urlGit=(''+unik.getFile(ukl)).replace(/\n/g, '')
        txta.text=urlGit
        var params=urlGit
        var m0=urlGit.split('/')
        var s1=(''+m0[m0.length-1]).replace('.git', '')
        var uklFileLocation=pws+'/link_'+s1+'.ukl'
        var uklData=''+urlGit
        txta.text+=' '+s1
        txta.text+=' '+pws
        uklData+=' -folder='+pws+'/'+s1
        unik.setFile(uklFileLocation, uklData)

        params+=', -folder='+pws+'/'+s1
        params+=', -dir='+pws+'/'+s1
        unik.setUnikStartSettings(params)
        //engine.load('qrc:/appsListLauncher.qml')
        unik.restartApp()
    }
}



