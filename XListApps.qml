import QtQuick 2.0

Item{
    id: r
    anchors.fill: parent
    visible: xApp.mod===1
    onVisibleChanged: if(visible)lv.focus=true
    property int modView: 0
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
                text: r.modView===0?'\uf069 '+r.modView:r.modView===1?'\uf00c '+r.modView:'\uf019 '+r.modView
                fontSize: app.fs
                animationEnabled: false
                blurEnabled: false
                anchors.verticalCenter: parent.verticalCenter
                anchors.right:  parent.right
                anchors.rightMargin: app.fs
                onClicked: {
                    if(r.modView===0){
                        r.modView=1
                    }else  if(r.modView===1){
                        r.modView=2
                    }else{
                        r.modView=0
                    }
                }
            }

        }
        ListView{
            id:lv
            width: r.width-app.fs
            height: r.height-app.fs*5
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: app.fs
            model:fl
            delegate: r.modView!==1 ? delegate : delegateInstalled
            Component{
                id:delegateInstalled
                UxBotRect{
                    id:xItemInstalled
                    height: app.fs*3+unikSettings.borderWidth*2
                    text: (''+fileName).substring(5, (''+fileName).length-4)
                    anchors.horizontalCenter: parent.horizontalCenter
                    animationEnabled: false
                    glowEnabled: false
                    onClicked: {
                        app.ca=app.al[index]
                        lv.currentIndex=index
                        run(fileName)
                    }
                    Rectangle{
                        id:aaa
                        anchors.fill: parent
                        color: 'yellow'
                    }
                    UText{
                        id:ddd
                        text:  'instalado'
                        font.pixelSize: 20
                        anchors.centerIn: parent
                        color: 'black'
                    }
                    Component.onCompleted:  {
                        let uklLocation = pws+'/'+fileName
                        let uklData = ''+unik.getFile(uklLocation)
                        if(uklData.indexOf('-folder=')){
                            let m0 = uklData.split('-folder=')
                            if(m0.length>0){
                                let m1=(''+m0[1]).split(' ')
                                let m2=m1[0]
                                ddd.text=m2
                                if(unik.fileExist(pws+'/unik-android-apps/'+m2+'/main.qml')){
                                    aaa.color='red'
                                    //xItemInstalled.visible=true
                                }else{
                                    aaa.color='blue'
                                    //xItemInstalled.visible=false
                                }
                            }
                        }else{
                            let mn = (''+fileName).replace('link_', '').replace('.ukl', '')
                            if(unik.fileExist(pws+'/unik-android-apps/'+mn+'/main.qml')){
                                aaa.color='pink'
                                //xItemInstalled.visible=true
                            }else{
                                aaa.color='green'
                                //xItemInstalled.visible=false
                            }
                        }
                    }
                }
            }
            Component{
                id:delegate
                UxBotRect{
                    id:xItem
                    height: app.fs*3+unikSettings.borderWidth*2
                    visible:(''+fileName).indexOf('link')===0&&(''+fileName).indexOf('.ukl')>0
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

                        //if( tlaunch.enabled){
                        timerInit.restart()
                        //}
                        if(xItem.width>lv.width){
                            lv.width=xItem.width
                        }
                        var uklFileLocation=pws+'/'+fileName
                        //xItem.installed=unik.fileExist(uklFileLocation)
                    }
                }                
            }
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
