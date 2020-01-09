import QtQuick 2.0

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

            //engine.load(pws+'/'+uModuleName+'/main.qml')
            //app.close()
        }
    }
    function run(fileName){
        let uklLocation = pws+'/'+app.moduleName+'/'+fileName
        let uklData = unik.getFile(uklLocation).replace(/\n/g, '')
        let params = uklData.replace(/ /g, ', ')
        unik.setUnikStartSettings(params)
        //uLogView.showLog(fileName)
        if(Qt.platform.os==='android'){
            unik.restartApp()
        }else{
            unik.restartApp("")
        }
    }
}
