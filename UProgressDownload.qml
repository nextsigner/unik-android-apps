import QtQuick 2.0
import QtQuick.Window 2.0

Rectangle{
    id: r
    opacity: 0.0
    width: parent.width
    //width: Screen.desktopAvailableWidth<Screen.desktopAvailableHeight ? Screen.desktopAvailableWidth*0.95 : Screen.desktopAvailableHeight*0.95
    height: titDownloadLog.contentHeight+log.contentHeight+pblaunch.height+app.fs
    //anchors.centerIn: parent
    color: app.c1
    //radius: unikSettings.radius
    border.width: unikSettings.borderWidth/2
    border.color: app.c2
    clip:true
    antialiasing: true

    property string fileName: unikSettings.lang==='es'?'archivo':'file'

    Connections {id: con1; target: unik;onUkStdChanged:setTxtLog(''+unik.ukStd);}
    Connections {id: con2; target: unik;onUkStdChanged: setTxtLog(''+unik.ukStd); }

    Behavior on opacity{
        NumberAnimation{duration: 1000}
    }
    Text {
        id: logDev
        font.pixelSize: 14
        width: r.width
        height: 300
        wrapMode: Text.WordWrap
        anchors.top: r.bottom
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
            id: log
            color: app.c2
            width: r.width//app.width<app.height ? app.width*0.9 : app.height*0.9
            height: contentHeight
            wrapMode: Text.WordWrap
            font.pixelSize: app.fs*0.5
            horizontalAlignment: Text.AlignHCenter
            /*function setTxtLog(t){
                logDev.text = t
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
            }*/
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
            r.visible=false
        }
    }
    Boton{//Close
        id: btnRestartDownload
        w:app.fs
        h: w
        t: "\uf021"
        d:unikSettings.lang==='es'?'Cerrar':'Close'
        b:app.c1
        c: app.c2
        anchors.right: parent.right
        anchors.rightMargin: app.fs*0.5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: app.fs*0.5
        onClicking: {
            pblaunch.width = 0
            download(r.uDownloadRequestUrl, r.uDownloadRequestFolder)
        }
    }
    function setTxtLog(t){
        logDev.text += t
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
                if(parseInt(m3)>0){
                    pblaunch.width=r.width/100*m3
                    r.color = app.c1
                }else{
                    r.color = 'red'
                }
            }

        }
        if(p){
            log.text=t
        }
    }
    property string uDownloadRequestUrl
    property string uDownloadRequestFolder
    function download(url, folder){
        uDownloadRequestUrl = url
        uDownloadRequestFolder = folder
        r.opacity = 1.0
        var d = unik.downloadGit(url, folder)
        r.opacity = 0.5
    }
}
