love_path = https://bitbucket.org/rude/love/downloads/
love = love-0.10.0-macosx-x64.zip

demo: main.lua conf.lua physics.lua sr.lua draw.lua
	love ./

Alfalfa.zip: Alfalfa.love love.app
	mv love.app Alfalfa.app
	cp Alfalfa.love Alfalfa.app/Contents/Resources
	sed -i.bak s/LÖVE/Alfalfa/g Alfalfa.app/Contents/Info.plist
	zip -r -q $@ Alfalfa.app

love.app: love-archive.zip
	unzip -q -o love-archive.zip

love-archive.zip:
	wget -O $@ $(love_path)$(love)

Alfalfa.love: main.lua conf.lua
	zip -9 -q -r $@ .

.PHONY: clean
clean:
	-rm *.zip
	-rm -rf *.app
	-rm -rf *.love
