@echo off
pushd C:\Users\pix\IdeaProjects\website-2019 & dart bin/superflat.dart file:///%* & popd
if NOT ["%errorlevel%"]==["0"] pause