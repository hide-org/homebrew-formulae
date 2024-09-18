class Hide < Formula
  desc "Headless IDE for AI agents"
  homepage "https://hide.sh"
  url "https://github.com/hide-org/hide/releases/download/v0.4.0/hide-0.4.0.tar.gz"
  sha256 "365f4896f351f142976379fb2d145c09adfdeba2db25cc540f6ea3d06250d395"
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
