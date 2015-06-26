import sys
from PIL import Image
from PIL.PngImagePlugin import PngInfo

png = Image.open('original.png')
pixels = png.load()

new_pixels = []
with open(sys.argv[1], "r") as kg:
    new_pixels = kg.read()

print "setting %d new pixels" % len(new_pixels)

k = 0

for i in range(png.size[0]):    # for every pixel:
    if k >= len(new_pixels):
        break
    for j in range(png.size[1]):
        r, g, b = list(pixels[i, j])
        b = new_pixels[k]  # change the blue pixel ;)
        pixels[i, j] = r, g, ord(b)
        k += 1
        if k >= len(new_pixels):
            break

info = PngInfo()
info.add_text("flag", "not here ...but john loves that song ;)")
png.save('Ub7XL8T.png', 'PNG', compress_level=9, pnginfo=info)
