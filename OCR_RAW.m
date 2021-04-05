I = imread('images/sign1.jpg');

ocrtxt = ocr(I, 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789')
[ocrtxt.Text]