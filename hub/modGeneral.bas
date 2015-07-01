Attribute VB_Name = "modGeneral"
Option Explicit
Public Declare Function GetTickCount Lib "kernel32" () As Long

Public PacketsSent As Long
Public PacketsReceived As Long
Public BytesSent As Long
Public BytesReceived As Long

Public Const MAX_LONG As Long = 2147483647

Sub Main()

Call InitMessages

frmServer.Show

AddLog "Starting Hub Server.."

Dim i As Integer

    With frmServer
    
    .Socket(0).RemoteHost = .Socket(0).LocalIP
    .Socket(0).LocalPort = 5000
    
    For i = 1 To MAX_SERVERS
        Load .Socket(i)
        ClearServer (i)
        'AddLog "Loading socket " & i
    Next i
    
    .Socket(0).Listen
    
    AddLog "Listening on port " & .Socket(0).LocalPort & ".."
    
    End With

UpdateCaption

End Sub

Public Sub AddLog(text As String)
    With frmServer.txtLog
    
    If .Visible = False Then Exit Sub
        .SelText = Time & ": " & text & vbCrLf
        '.Text = .Text & vbCrLf & Time & ": " & Text
    End With
End Sub

Public Function GetRealTickCount() As Long
    If GetTickCount < 0 Then
        GetRealTickCount = GetTickCount + MAX_LONG
    Else
        GetRealTickCount = GetTickCount
    End If
End Function

Sub UpdateTrafficStadistics()
    frmServer.lblPacketsReceived.Caption = "Packets Received / Second: " & PacketsReceived
    frmServer.lblPacketsSent.Caption = "Packets Sent / Second: " & PacketsSent
    frmServer.lblBytesSent.Caption = "Bytes Sent / Second: " & BytesSent
    frmServer.lblBytesReceived.Caption = "Bytes Received / Second: " & BytesReceived
    
    PacketsReceived = 0
    PacketsSent = 0
    BytesSent = 0
    BytesReceived = 0

End Sub

Sub UpdateCaption()
    frmServer.Caption = "Hub Server - Servers: " & TotalServers & " Players: " & TotalPlayers
End Sub

Public Function TotalServers() As Integer
    Dim total As Integer
    Dim i As Integer
    For i = 1 To MAX_SERVERS
        If frmServer.Socket(i).State = sckConnected Then total = total + 1
    Next
    
    TotalServers = total
End Function

Public Function TotalPlayers() As Long
    Dim total As Long
    Dim i As Integer
    For i = 1 To MAX_SERVERS
        total = total + Server(i).CurrentPlayers
    Next
    
    TotalPlayers = total
End Function

Public Function ConvertTime(msec As Long) As String
    msec = msec \ 1000
    ConvertTime = Format$((msec \ 3600) \ 24, "00d ") _
                 & Format$((msec \ 3600) Mod 24, "00h ") _
                 & Format$((msec Mod 3600) \ 60, "00m ") _
                 & Format$((msec Mod 60), "00s ")
End Function

