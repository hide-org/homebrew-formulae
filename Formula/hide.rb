class Hide < Formula
  desc "Headless IDE for AI agents"
  homepage "https://hide.sh"
  url "https://github.com/hide-org/hide/releases/download/v0.5.0/hide-0.5.0.tar.gz"
  sha256 "0ba7a5aa4ad5074589aec27cea1d5c433e62963bff50e0798ededa89be4c5957"
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
