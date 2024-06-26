class Hide < Formula
  desc "Headless IDE for AI agents"
  homepage "https://hide.sh"
  url "https://github.com/artmoskvin/hide/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "799201a68247d077ca6ec36e921be1a8cc99a3c7fdd2f8dcc0f8aaf0fe1f9a31"
  license "MIT"

  depends_on "go" => :build
  depends_on "docker"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/hide"
  end

  test do
    read, write = IO.pipe

    pid = fork do
      $stdout.reopen(write)
      $stderr.reopen(write)
      exec "#{bin}/hide"
    end

    write.close

    sleep 2

    begin
      output = read.read_nonblock(4096)
      assert_match "Server started on :8080", output
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
