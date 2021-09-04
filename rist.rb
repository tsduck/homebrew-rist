class Rist < Formula

  desc "RIST Reliable Internet Stream Transport"
  homepage "https://code.videolan.org/rist/"

  version "0.2.6"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.6/librist-v0.2.6.tar.gz"
  sha256 "88b35b86af1ef3d306f33674f2d9511a27d3ff4ec76f20d3a3b3273b79a4521d"
  license "BSD"
  
  head "https://code.videolan.org/rist/librist.git"

  depends_on "cjson"
  depends_on "cmocka"
  depends_on "mbedtls"
  depends_on "ninja" => :build
  depends_on "meson" => :build

  def install
    system "mkdir", "build"
    system "meson", "build", "."
    system "ninja", "-C", "build"
    system "mkdir", "-p", "#{prefix}/bin", "#{prefix}/lib", "#{prefix}/include/librist"
    system "install", "-m", "755", "build/tools/rist2rist", "#{prefix}/bin"
    system "install", "-m", "755", "build/tools/ristreceiver", "#{prefix}/bin"
    system "install", "-m", "755", "build/tools/ristsender", "#{prefix}/bin"
    system "install", "-m", "755", "build/tools/ristsrppasswd", "#{prefix}/bin"
    system "sh", "-c", "tar -cpf - build/librist*.dylib | tar -C #{prefix}/lib --strip-components 1 -xpf -"
    system "sh", "-c", "install -m 644 build/include/*.h build/include/librist/*.h include/librist/*.h #{prefix}/include/librist"
  end

end
