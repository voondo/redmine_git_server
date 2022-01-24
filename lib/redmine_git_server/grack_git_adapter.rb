
module RedmineGitServer
  class GrackGitAdapter < Grack::GitAdapter

    def command(cmd, args, io_in, io_out, dir = nil)
      cmd = [git_path, cmd] + args
      opts = {:err => :close}
      opts[:chdir] = dir unless dir.nil?
      cmd << opts
      IO.popen(cmd, 'r+b') do |pipe|
        while !io_in.nil? do
          chunk = io_in.read(READ_SIZE)
          break if chunk.nil?
          pipe.write(chunk)
        end
        pipe.close_write
        while !pipe.eof? do
          chunk = pipe.read(READ_SIZE)
          unless io_out.nil?
            io_out.write(chunk)
          end
        end
      end
    end

  end
end
