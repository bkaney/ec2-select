module Ec2Select

  class NoEctwoFile <  StandardError; end;

  ECTWOS_FILE = File.expand_path('~/.ec2-select')  

  def rewrite_or_show(profile=nil)
    return show if profile.nil?
    rewrite(profile) unless profile.nil?
  end

  def show
    current = ENV['EC2_PRIVATE_KEY'].gsub(/.*pk-(.*)\.pem$/, '\\1')
    "Your current profile is: #{current}"
  end

  def pempath
    ENV['EC2_PEMFILES'] ? File.expand_path(ENV['EC2_PEMFILES']) : File.expand_path('~/.ec2')
  end

  def shell
    unless const_defined? 'SHELL'
      begin
        require File.expand_path('~/.ec2-select')
      rescue LoadError
        const_set("SHELL", 'bash')
      end
    end
    SHELL
  end

  def private_key(profile)
    "#{pempath}/pk-#{profile}.pem"
  end

  def cert(profile)
    "#{pempath}/cert-#{profile}.pem"
  end

  def rewrite(profile)
    # Validation
    if profile !~ /[A-Za-z0-9\.\-_~+=]/
      raise "Uh Oh!  Profile can only have valid filename characters!"
    end
    if !File.exist? private_key(profile)
      raise "Private key #{private_key(profile)} does not exist!"
    end
    if !File.exist? cert(profile)
      raise "Cert #{cert(profile)} does not exist!"
    end

    # Content
    content = "# Dynamically created by ec2-select\n"
    content << "# Currently PROFILE=#{profile}\n\n"
    content << case shell
    when /bash|.?sh/
      "export EC2_PRIVATE_KEY=\"#{private_key(profile)}\"\n" +
      "export EC2_CERT=\"#{cert(profile)}\"\n"
    when /.?csh/
      "setenv EC2_PRIVATE_KEY \"#{private_key(profile)}\"\n" +
      "setenv EC2_CERT \"#{cert(profile)}\"\n"
    else
      $stderr.puts "Unknown shell `#{shell}'"
      exit 1
    end
    

    File.open(ECTWOS_FILE, 'w') {|f| f.write(content) }

    "IMPORTANT!!! You need re-source if you want to use #{profile}\n" +
    "in this terminal session!  This should do the trick:\n" +
    "\n  source #{ECTWOS_FILE}\n\n" +
    "Any new terminal sessions will use this profile as long as you\n" +
    "have 'source #{ECTWOS_FILE}' in your ~/.profile or\n" +
    "~/.bashrc, ~/.bash_profile (or similar)."
  end

end
