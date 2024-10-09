class Hide < Formula
  desc "Headless IDE for AI agents"
  homepage "https://hide.sh"
  url "https://github.com/hide-org/hide/releases/download/v0.4.1/hide-0.4.1.tar.gz"
  sha256 "0e39e62a64fc7f89e14ff3196350523809ccde11fb807b2ca102a9631edc58ce"
  license "MIT"

  depends_on "go" => :build
  depends_on "gopls"
  depends_on "pyright"
  depends_on "typescript-language-server"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    read, write = IO.pipe

    pid = fork do
      $stdout.reopen(write)
      $stderr.reopen(write)
      exec bin/"hide"
    end

    write.close

    sleep 2

    begin
      output = read.read_nonblock(4096)
      assert_match "headless IDE for coding agents", output
    rescue IO::WaitReadable
      read.wait_readable(1)
      retry
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
      read.close
    end
  end
end
