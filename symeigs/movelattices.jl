sg = first(parse.(Int, ARGS))

for id in 1:10000
	(id%100 == 0) && println(id)
	flush(stdout)
	for eps in 1:3
		for mode in ["te", "tm"]
			filename_dispersion = "dim2-sg$sg-$(id+(eps-1)*10000)-res64-$(mode)-dispersion.out"
			mv("./output/sg$(sg)/$(filename_dispersion)", "./output/sg$(sg)/eps$(eps)/$mode/$(filename_dispersion)")

			filename_symeigs = "dim2-sg$sg-$(id+(eps-1)*10000)-res64-$(mode)-symeigs.out"
			mv("./output/sg$(sg)/$(filename_symeigs)", "./output/sg$(sg)/eps$(eps)/$mode/$(filename_symeigs)")

			filename_epsilon = "dim2-sg$sg-$(id+(eps-1)*10000)-res64-$(mode)-epsilon.h5"
			mv("./output/sg$(sg)/$(filename_epsilon)", "./output/sg$(sg)/eps$(eps)/$mode/$(filename_epsilon)")
		end
	end
end
