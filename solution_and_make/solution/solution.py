from PIL import Image

# python solution.py > output | gzip --decompress > out

png = Image.open('Ub7XL8T.png')
pixels = png.load()

out = ""

for i in range(png.size[0]):    # for every pixel:
    for j in range(png.size[1]):
        r, g, b = list(pixels[i, j])
        out += chr(b)

print out
