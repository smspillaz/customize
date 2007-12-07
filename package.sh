rm -f *.o
rm -rf CustomizeApp/.DS_Store
rm -rf CustomizeApp/*/.DS_Store
mv Customize CustomizeApp/Customize
mv CustomizeApp Customize.app
tar -cf Customize.tar Customize.app
mv Customize.app CustomizeApp