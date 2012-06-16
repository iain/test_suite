module IOHelper

  def capture
    stdout = StringIO.new
    stderr = StringIO.new
    $stdout = stdout
    $stderr = stderr
    yield
    stdout.rewind
    stderr.rewind
    [ stdout.read, stderr.read ]
  ensure
    $stdout = STDOUT
    $stderr = STDERR
  end

end
