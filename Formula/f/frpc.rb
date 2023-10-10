class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.52.0",
      revision: "2d3af8a108518b7a9540592735274b34d7031bf0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c38ccef259e8c660dc73265d737d236e178be0e6d01e756c0ffc72ef603d4328"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "132004b6c5c5f5fed10b2a65e2d3a8983d6b2e34f05959177eb72ebd9e7ce978"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "132004b6c5c5f5fed10b2a65e2d3a8983d6b2e34f05959177eb72ebd9e7ce978"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "132004b6c5c5f5fed10b2a65e2d3a8983d6b2e34f05959177eb72ebd9e7ce978"
    sha256 cellar: :any_skip_relocation, sonoma:         "7957c36ee1a3a048c7f93ce7e6adb4b96286be46ad8afacf58f7a57baff410d5"
    sha256 cellar: :any_skip_relocation, ventura:        "c938670eba0bde6ca00d3dbd6985ae49327767339c4317c49b665da1dcadaa34"
    sha256 cellar: :any_skip_relocation, monterey:       "c938670eba0bde6ca00d3dbd6985ae49327767339c4317c49b665da1dcadaa34"
    sha256 cellar: :any_skip_relocation, big_sur:        "c938670eba0bde6ca00d3dbd6985ae49327767339c4317c49b665da1dcadaa34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c8882d2655579be816e5f85fcbe6cd6567d1fb0eff1d6bdd57a1b68751c709f"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frpc"
    bin.install "bin/frpc"
    etc.install "conf/frpc.toml" => "frp/frpc.toml"
  end

  service do
    run [opt_bin/"frpc", "-c", etc/"frp/frpc.toml"]
    keep_alive true
    error_log_path var/"log/frpc.log"
    log_path var/"log/frpc.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frpc -v")
    assert_match "Commands", shell_output("#{bin}/frpc help")
    assert_match "name should not be empty", shell_output("#{bin}/frpc http", 1)
  end
end
