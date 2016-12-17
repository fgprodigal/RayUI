local LSM = LibStub("LibSharedMedia-3.0")

if LSM == nil then return end

LSM:Register("statusbar","RayUI Light", [[Interface\AddOns\RayUI\media\statusbar_light.tga]])
LSM:Register("statusbar","RayUI Dark", [[Interface\AddOns\RayUI\media\statusbar_dark.tga]])
LSM:Register("statusbar","RayUI Qulight", [[Interface\AddOns\RayUI\media\statusbar_qulight.tga]])
LSM:Register("statusbar","RayUI Blank", [[Interface\BUTTONS\WHITE8X8]])
LSM:Register("statusbar","RayUI Gloss", [[Interface\AddOns\RayUI\media\gloss.tga]])
LSM:Register("border", "RayUI GlowBorder", [[Interface\AddOns\RayUI\media\glowTex.tga]])
LSM:Register("sound","RayUI Error", [[Interface\AddOns\RayUI\media\error.mp3]])
if GetLocale() == "zhCN" then
	LSM:Register("font","RayUI Font", [[Fonts\ARKai_T.ttf]], 255)
	LSM:Register("font","RayUI Combat", [[Fonts\ARKai_C.ttf]], 255)
elseif GetLocale() == "zhTW" then
	LSM:Register("font","RayUI Font", [[Fonts\bLEI00D.ttf]], 255)
	LSM:Register("font","RayUI Combat", [[Fonts\bKAI00M.ttf]], 255)
end
LSM:Register("font","RayUI Pixel", [[Interface\AddOns\RayUI\media\pixel.ttf]], 255)
LSM:Register("font","RayUI Roadway", [[Interface\AddOns\RayUI\media\ROADWAY.ttf]], 255)
LSM:Register("font","RayUI Arrows", [[Interface\AddOns\RayUI\media\arrows.ttf]], 255)
LSM:Register("font","RayUI Octicons", [[Interface\AddOns\RayUI\media\octicons.ttf]], 255)
