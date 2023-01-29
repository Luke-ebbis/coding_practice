#! /usr/bin/env julia
import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.julialang 1.0

ApplicationWindow {
    title: "My Application"
    width: 480
    height: 640
    visible: true

    Connections {
      target: timer
      onTimeout: Julia.counter_slot()
    }

    ColumnLayout {
      spacing: 6
      anchors.centerIn: parent

      Button {
          Layout.alignment: Qt.AlignCenter
          text: "Start counting"
          onClicked: timer.start()
      }

      Text {
          Layout.alignment: Qt.AlignCenter
          text: bg_counter.toString()
      }

      Button {
          Layout.alignment: Qt.AlignCenter
          text: "Stop counting"
          onClicked: timer.stop()
      }
  }
}

