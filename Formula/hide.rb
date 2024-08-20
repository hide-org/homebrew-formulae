class Hide < Formula
  desc "Headless IDE for AI agents"
  homepage "https://hide.sh"
  url "https://github.com/artmoskvin/hide/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "a0fbfb8b7bf05b05b508c7b34b7bad78a3173b86de2a22ecc1797e369b0e28f8"
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
