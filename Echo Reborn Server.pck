GDPC                                                                                0   res://Autoload Scripts/server_starter.gd.remap  �      :       ��?G �� ҽ�SD��,   res://Autoload Scripts/server_starter.gdc   �      �      R� ��ӕ?��7��@�(   res://Characters/PlayerServer.gd.remap        2       x�"�i��ҿbw/�t$   res://Characters/PlayerServer.gdc          s      m3�
��B���1]���$   res://Characters/PlayerServer.tscn  �      �       �Zԡ�[=�/�A�Et8   res://Characters/SurvivorServer/SurvivorServer.gd.remap P      C       4D�;c4�{37#Z���v4   res://Characters/SurvivorServer/SurvivorServer.gdc  P      {      �X<f(_��88�R�4   res://Characters/SurvivorServer/SurvivorServer.tscn �      �       2*���RD�2��a��q   res://Server.tscn   �      �      �}_^#
^+{����(   res://ServerScenes/GameLobbyServer.tscn p      A       ;��LE/�ܩCC���7(   res://ServerScenes/LobbyServer.gd.remap �      3       �#:�u霰��1���$   res://ServerScenes/LobbyServer.gdc  �      `      �".�㗀���&�A�$   res://ServerScenes/LobbyServer.tscn        �       ��o�/�t�I�y�[d��   res://project.binary�      i      �v���`�5�eg��    GDSC          <   &     ���Ӷ���   ��������涶�   �����������   �����������   �����������Ķ���   �����������Ŷ���   ������ٶ   ���Ӷ���   �����϶�   �������Ӷ���   ������¶   ���Ķ���   �����������������������¶���   ����   ������������Ķ��   ���������������Ķ���   ����������������Ҷ��   �Ҷ�   ����������������Ķ��   �������������������Ҷ���   ������������ݶ��   �������������������Ҷ���   ��������������ڶ   ��������������Ӷ   �������Ӷ���   �������Ӷ���   �����������������Ķ�   �����Ҷ�   ���������¶�   �������Ӷ���   ��������Ҷ��   �����Ҷ�   	   127.0.0.1      (#     d      "   res://Characters/PlayerServer.tscn     
   MainServer        network_peer_connected        _player_connected         network_peer_disconnected         _player_disconnected      connected_to_server       _connected_ok         connection_failed         _connected_fail       server_disconnected       _server_disconnected      El servidor esta ON en puerto          se ha conectado al Servidor      root      Lobby                                   	                           	      
                &      '      0      1      7      D      Q      ^      k      x      y      z      �      �      �      �      �      �      �      �       �   !   �   "   �   #   �   $   �   %   �   &   �   '   �   (   �   )   �   *   �   +   �   ,   �   -   �   .   �   /   �   0   �   1   �   2   �   3   �   4   �   5   �   6   �   7      8     9     :   !  ;   $  <   3YYY:�  Y:�  �  Y:�  �  YY5;�  ?P�  QY�  YY;�  LMYY;�  N�  �  OYY0�  PQV�  �	  PQT�
  P�  RR�  Q�  �	  PQT�
  P�  RR�  Q�  �	  PQT�
  P�	  RR�
  Q�  �	  PQT�
  P�  RR�  Q�  �	  PQT�
  P�  RR�  Q�  �  �  ;�  �  T�  PQ�  �  �  T�  P�  R�  Q�  �	  PQT�  P�  Q�  �8  P�  R�  Q�  -YY0�  P�  QV�  �8  P�  R�  Q�  �  P�  Q�  �  -�  Y0�  P�  QVYYY�  -YY0�  PQV�  -YY0�  PQV�  -YY0�  PQV�  -YY0�  P�  QV�  ;�  �  T�  PQ�  �  T�  P�7  P�  QQ�  �  T�  P�  Q�  �  T�  P�  Q�  �  PQT�  P�  QT�  P�  QT�  P�  Q�  �  T�  P�  Q�  .�  Y`               GDSC            2      ���ӄ�   ����Ҷ��   �����϶�   ����������Ķ   �Ҷ�   �������������Ӷ�   �����Ҷ�                                            	               	      
                                  "      #      *      .      3YYYY;�  YY0�  PQV�  -YYD0�  P�  R�  QVYYY�  �  -�  Y0�  P�  QV�  �  �  �  .`             [gd_scene load_steps=2 format=2]

[ext_resource path="res://Characters/PlayerServer.gd" type="Script" id=1]


[node name="Player" type="Node2D"]
script = ExtResource( 1 )
     GDSC            3      ���ӄ�   �����϶�   �������������Ӷ�   ����¶��   �������Ӷ���   ����������������Ҷ��   ��ն      Moviendo a         hacia        move                                                    	      
         )      0      3YYYY0�  PQV�  -YYYD0�  P�  QV�  �  �8  PR�  PQT�  PQR�  R�  Q�  �  P�  R�  Q�  -`     [gd_scene load_steps=2 format=2]

[ext_resource path="res://Characters/SurvivorServer/SurvivorServer.gd" type="Script" id=1]


[node name="SurvivorServer" type="Node2D"]
script = ExtResource( 1 )
            [gd_scene load_steps=2 format=2]

[ext_resource path="res://ServerScenes/LobbyServer.tscn" type="PackedScene" id=1]

[node name="root" type="Node"]

[node name="Lobby" parent="." instance=ExtResource( 1 )]

[node name="Control TODO" type="Control" parent="."]
margin_left = 300.0
margin_top = 45.0
margin_right = 700.0
margin_bottom = 545.0

[node name="PanelContainer" type="PanelContainer" parent="Control TODO"]
margin_right = 400.0
margin_bottom = 500.0
      [gd_scene format=2]

[node name="GameLobbyServer" type="Node2D"]
               GDSC            m      ���ӄ�   ��������϶��   ����������������Ŷ��   ����������Ѷ   �������������������Ķ���   ������Ҷ   �������������Ӷ�   �����������������Ӷ�   �������Ӷ���   �������Ӷ���   �����������������Ķ�   ���������¶�   ��������Ҷ��   ��ն   '   res://ServerScenes/GameLobbyServer.tscn        Creando nuevo gamelobbyServer -                    new_gamelobby                                                       	      
               !      "      #      $      .      5      9      :      <      ?      H      O      V      _      `      i      k      3YY5;�  ?PQYYY;�  LMYYYYD0�  PQV�  �  -YYYYD0�  P�  R�  QV�  �8  P�  R�  Q�  &�  V�  �  -�  (V�  ;�  �  T�  PQ�  �  T�	  P�  Q�  �  T�
  P�  Q�  �  PQT�  P�  Q�  �  �  P�  R�  R�  Q�  -�  `[gd_scene load_steps=2 format=2]

[ext_resource path="res://ServerScenes/LobbyServer.gd" type="Script" id=1]


[node name="Lobby" type="Node2D"]
script = ExtResource( 1 )
     [remap]

path="res://Autoload Scripts/server_starter.gdc"
      [remap]

path="res://Characters/PlayerServer.gdc"
              [remap]

path="res://Characters/SurvivorServer/SurvivorServer.gdc"
             [remap]

path="res://ServerScenes/LobbyServer.gdc"
             ECFG      _global_script_classes             _global_script_class_icons             application/config/name         Echo Reborn Server     application/run/main_scene         res://Server.tscn      autoload/PlayerConector4      )   *res://Autoload Scripts/server_starter.gd   )   rendering/environment/default_clear_color      ���=���>���=  �?       GDPC