class Vman
	def off
		system('VBoxManage controlvm Win7  setlinkstate1 off')
	end

	def on
		system('VBoxManage controlvm Win7  setlinkstate1 on')
	end
end