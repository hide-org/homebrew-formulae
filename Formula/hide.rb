class Hide < Formula
  desc "Headless IDE for AI agents"
  homepage "https://hide.sh"
  url "https://github.com/artmoskvin/hide/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "84726116073d42b0d4beb476ead493a7efe88c1c7cc8141e4b1d64054f0c30c3"
  license "MIT"

  depends_on "go" => :build
  depends_on "docker"
  depends_on "git"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/hide"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test hide`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
