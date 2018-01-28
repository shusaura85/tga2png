# Targa2PNG

Targa2PNG is a small console based application to convert Truevision Targa images (*.tga) to Portable Network Graphics (*.png) with alpha transparency.

# Usage

    targa2png.exe <input_tga_file> [<output_png_file>] [<invert_mask>]

 - **<input_tga_file>** - Filename of the input TGA image
 - **<output_png_file>** - Filename of the output PNG image. If not specified, the input file name will be used with .png extension
 - **<invert_mask>** - If the TGA image has an inverted mask, set this to 1 to invert mask data. If not specified, mask data from TGA will be used as is.

