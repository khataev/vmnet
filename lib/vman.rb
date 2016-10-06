require 'net/ping'

class Vman

  def off
    Vman.off
  end

  def on
    Vman.on
  end

	def self.off
		system('sudo -u khataev VBoxManage controlvm Win7  setlinkstate1 off')
	end

	def self.on
		system('sudo -u khataev VBoxManage controlvm Win7  setlinkstate1 on')
  end

  def self.check_ping_guest
    @icmp = Net::Ping::ICMP.new('192.168.1.199')

    unless @icmp.ping
      puts "unless ping: #{@icmp.ping}"
      self.off
      sleep(10)
      self.on
    end
  end
end