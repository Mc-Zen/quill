import unittest
import pdf2image
import run_typst
from pixelmatch.contrib.PIL import pixelmatch
from PIL import Image

test_directory = "tests/"
ref_directory = test_directory + "references/"


class TypstTest(unittest.TestCase):
    def run_typst(self, filename):
        output, exit_code = run_typst.run_typst("references/" + filename)
        self.assertEqual(exit_code, 0, msg=f"Typst compilation failed: {output}")


class TypstImageTest(TypstTest):
    def loadPDFAsImage(self, filename, dpi=200):
        return pdf2image.convert_from_path(filename, dpi, fmt="png")

    def loadPDFPageAsImage(self, filename, page=0, dpi=200):
        return self.loadPDFAsImage(ref_directory + filename, dpi=dpi)[page]

    def assertEqualImage(self, image1, image2, threshold=.1, maxInequalPixels=0):
        num_diff_pixels = pixelmatch(image1, image2, None, threshold=threshold)
        self.assertLessEqual(num_diff_pixels, maxInequalPixels)

    def storeReferenceImage(self, image: Image, filename):
        image.save(ref_directory + filename)

    def loadReferenceImage(self, filename) -> Image:
        return Image.open(ref_directory + filename)

    def compile_and_get_image(self, filename, dpi):
        self.run_typst(filename)
        return self.loadPDFPageAsImage(filename.replace(".typ", ".pdf"), dpi=dpi)

    def compile_and_store_reference(self, filename, outfilename=None, dpi=200):
        if outfilename is None:
            outfilename = filename.replace(".typ", ".png")
        img = self.compile_and_get_image(filename, dpi=dpi)
        self.storeReferenceImage(img, outfilename)

    def compile_and_assert_correct(self, filename):
        img = self.compile_and_get_image(filename, dpi=200)
        reference = self.loadReferenceImage(filename.replace(".typ", ".png"))
        self.assertEqualImage(img, reference)


class Test(TypstImageTest):
    def test_r(self):
        self.run_typst("empty_document.typ")
        self.run_typst("qft.typ")
        self.run_typst("teleportation.typ")

    def test_examples(self):
        self.compile_and_assert_correct("phase-estimation.typ")
        self.compile_and_assert_correct("qft.typ")
        self.compile_and_assert_correct("teleportation.typ")

    def test_run_examples(self):
        self.compile_and_store_reference("../../examples/bell.typ", outfilename="../../docs/images/bell.png", dpi=300)
