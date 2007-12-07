CC=arm-apple-darwin-cc
LD=$(CC)
LDFLAGS=-lobjc -framework CoreFoundation -framework Foundation -framework UIKit -framework LayerKit -framework CoreGraphics -framework Celestial -framework GraphicsServices -framework WebCore -framework WebKit

all: Customize

Customize:  mainapp.o CustomizeApp.o ChooserView.o ChooserTableCell.o SelectionView.o \
            CSPreferencesTableCell.o AudioChooserView.o AudioSelectionView.o StringEditorView.o \
						ConfigureView.o DeviceInfo.o \
            toolchain_patch.o \
            DisplayOrder/DisplayOrderView.o DisplayOrder/AppObject.o DisplayOrder/ListSortView.o \
						DisplayOrder/PresetLoaderView.o DisplayOrder/RuleParser.o DisplayOrder/ToggleDockNumView.o
	$(LD) $(LDFLAGS) -v -o $@ $^

%.o:    %.m
		$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

nice:
		rm -f *.o

clean:
		rm -f *.o Customize

package: all
	mv Customize CustomizeApp/
	mv CustomizeApp Customize.app
	tar -cf Customize.tar Customize.app
	gzip Customize.tar
	mv Customize.app CustomizeApp

