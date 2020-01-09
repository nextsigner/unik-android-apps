import QtQuick 2.0
import QtQuick.Window 2.0

Rectangle{
    id: r
    enabled: opacity!==0.0
    opacity: 0.0
    width: parent.width
    height: colDownloadLog.height+app.fs*2//titDownloadLog.contentHeight+log.contentHeight+pblaunch.height+app.fs
    color: app.c1
    border.width: unikSettings.borderWidth/2
    border.color: app.c2
    clip:true
    antialiasing: true

    signal downloaded

    property string fileName: ''
    property string infoText: ''

    Connections {id: con1; target: unik;onUkStdChanged:setTxtLog(''+unik.ukStd);}
    Connections {id: con2; target: unik;onUkStdChanged: setTxtLog(''+unik.ukStd); }

    Behavior on opacity{
        NumberAnimation{duration: 1000}
    }
    MouseArea{
        anchors.fill: r
        enabled: r.opacity===1.0
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
            text: unikSettings.lang==='es'?'<b>Descargando '+r.fileName+'</b>':'<b>Downloading '+r.fileName+'</b>'
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text{
            id: txtInfoText
            text: r.infoText
            color: app.c2
            width: app.width<app.height ? app.width*0.9 : app.height*0.9
            height: contentHeight
            wrapMode: Text.WordWrap
            font.pixelSize: app.fs
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text{
            id: log
            color: app.c2
            width: r.width-app.fs//app.width<app.height ? app.width*0.9 : app.height*0.9
            height: contentHeight<app.fs*4?app.fs*4:contentHeight
            wrapMode: Text.WordWrap
            font.pixelSize: app.fs
            horizontalAlignment: Text.AlignHCenter
            textFormat: Text.RichText
        }
        Row{
            //height: app.fs*3
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: app.fs
            UxBotCirc{
                text: '\uf00d'
                fontSize: app.fs
                animationEnabled: false
                blurEnabled: false
                onClicked: {
                    r.opacity = 0.0
                }
            }
            UxBotCirc{
                text: '\uf021'
                fontSize: app.fs
                animationEnabled: false
                blurEnabled: false
                onClicked: {
                    pblaunch.width = 0
                    download(r.uDownloadRequestUrl, r.uDownloadRequestFolder)
                }
            }
            UxBotCirc{
                id:botCheck
                text: '\uf00c'
                fontSize: app.fs
                animationEnabled: false
                blurEnabled: false
                opacity: 0.0
                onClicked: {
                    r.opacity = 0.0
                }
                Behavior on opacity {NumberAnimation{duration: 1000}}
            }
        }
        Item{
            width: r.width
            height: xLabelPB.height
            Rectangle{
                width: parent.width
                height: app.fs*0.5
                color: 'transparent'
                border.width: 1
                border.color: app.c2
                anchors.verticalCenter: parent.verticalCenter
                Rectangle{
                    id:pblaunch
                    height: app.fs*0.5
                    width: 0
                    color: app.c4//'red'
                }
            }
            Rectangle{
                id:xLabelPB
                width: labelPB.contentWidth+app.fs
                height: width
                radius: width*0.5
                color: app.c1
                border.color: app.c2
                border.width: unikSettings.borderWidth*0.5
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    id: labelPB
                    text: '%0'
                    color: app.c2
                    font.pixelSize: app.fs
                    anchors.centerIn: parent
                }
            }

        }
    }

    function setTxtLog(t){
        let m3
        var  d=(''+t).replace(/\n/g, ' ')
        var p=true
        if(d.indexOf('Socket')>=0){
            p=false
        }else if(d.indexOf('download git')>=0){
            var m0=''+d.replace('download git ','')
            var m1=m0.split(' ')
            if(m1.length>1){
                var m2=(''+m1[1]).replace('%','')
                m3=parseInt(m2.replace(/ /g,''))
                if(parseInt(m3)>0){
                    pblaunch.width=r.width/100*m3
                    labelPB.text='%'+m3
                    r.color = app.c1
                }else{
                    r.color = 'red'
                }
            }

        }
        if(p && m3<100){
            log.text=t
        }else{
            if(m3>=100){
                log.text = unikSettings.lang === 'es'?uDownloadRequestUrl+' se ha descargado correctamente.':uDownloadRequestUrl+' download successful.'
            }
        }
    }
    property string uDownloadRequestUrl
    property string uDownloadRequestFolder
    function download(url, folder){
        botCheck.opacity = 0.0
        if(r.fileName===''){
            let m0 = url.split('/')
            let m1 =  m0[m0.length-1]
            fileName = m1//.replace(/\./, '')
        }
        uDownloadRequestUrl = url
        uDownloadRequestFolder = folder
        r.opacity = 1.0
        var d = unik.downloadGit(url, folder)
        botCheck.opacity = 1.0
        downloaded()
    }
}
