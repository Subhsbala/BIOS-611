.PHONY: clean

clean:
	rm -rf figures
	rm -rf derived_data
	rm -f .created-dirs

.created-dirs: 
	mkdir -p figures
	mkdir -p derived_data
	touch .created-dirs

derived_data/In-patient.csv: .created-dirs\
	./Data\ source/In-patient/MUP_IHP_RY23_P03_V10_DY16_GEO.CSV\
  ./Data\ source/In-patient/MUP_IHP_RY23_P03_V10_DY17_GEO.CSV\
  ./Data\ source/In-patient/MUP_IHP_RY23_P03_V10_DY18_GEO.CSV\
  ./Data\ source/In-patient/MUP_IHP_RY23_P03_V10_DY19_GEO.CSV\
  ./Data\ source/In-patient/MUP_IHP_RY23_P03_V10_DY20_GEO.CSV\
  ./Data\ source/In-patient/MUP_IHP_RY23_P03_V10_DY21_GEO.CSV\
  Pre_process1.R
	Rscript Pre_process1.R
	
derived_data/Out-patient.csv: .created-dirs\
  ./Data\ source/Out-patient/MUP_OHP_R19_P04_V40_D16_GEO.CSV\
  ./Data\ source/Out-patient/MUP_OHP_R19_P04_V40_D17_GEO.CSV\
  ./Data\ source/Out-patient/MUP_OHP_R20_P04_V10_D18_GEO.CSV\
  ./Data\ source/Out-patient/MUP_OUT_RY21_P04_V10_DY19_GEO.CSV\
  ./Data\ source/Out-patient/MUP_OUT_RY22_P04_V10_DY20_GEO.CSV\
  ./Data\ source/Out-patient/MUP_OUT_RY23_P04_V10_DY21_GEO.CSV\
  Pre_process2.R
	Rscript Pre_process2.R

derived_data/Part_D.csv: .created-dirs\
	./Data\ source/Pat\ D\ Drug/MUP_DPR_RY21_P04_V10_DY16_GEO_0.CSV\
  ./Data\ source/Pat\ D\ Drug/MUP_PTD_R19_P16_V10_D17_GEO.CSV\
  ./Data\ source/Pat\ D\ Drug/MUP_DPR_RY21_P04_V10_DY18_GEO.CSV\
  ./Data\ source/Pat\ D\ Drug/MUP_DPR_RY21_P04_V10_DY19_GEO.CSV\
  ./Data\ source/Pat\ D\ Drug/MUP_DPR_RY22_P04_V10_DY20_GEO.CSV\
  ./Data\ source/Pat\ D\ Drug/MUP_DPR_RY23_P04_V10_DY21_GEO.CSV\
  Pre_process3.R
	Rscript Pre_process3.R
	
derived_data/Demographics.csv: .created-dirs\
	./Data\ source/state_stdprices.csv\
  ./Data\ source/Pop_by_Age_Sex.csv\
  ./Data\ source/Pop_by_Race.csv\
  ./Data\ source/Pop_by_Income.csv\
  Pre_process4.R
	Rscript Pre_process4.R
	
derived_data/Out-patient_Geo.csv: .created-dirs\
  ./derived_data/Out-patient.csv\
  Derive_regions.R
	Rscript Derive_regions.R
	
derived_data/OP_Musculoskeletal.csv: .created-dirs\
	./derived_data/Out-patient_Geo.csv\
  ./derived_data/Demographics.csv\
  Pre_process5.R
	Rscript Pre_process5.R
	
derived_data/OP_utilization.csv: .created-dirs\
	./derived_data/OP_Musculoskeletal.csv\
  Pre_process6.R
	Rscript Pre_process6.R
	
figures/total_cost_OP.png: .created-dirs\
  ./derived_data/Out-patient_Geo.csv\
  Plot_total_cost.R
	Rscript Plot_total_cost.R
	
figures/total_cost_perdisc_OP.png: .created-dirs\
  ./derived_data/Out-patient_Geo.csv\
  Plot_total_cost_per_discharge.R
	Rscript Plot_total_cost_per_discharge.R
	
figures/Top10_APC.png: .created-dirs\
  ./derived_data/Out-patient_Geo.csv\
  Top10_APC.R
	Rscript Top10_APC.R
	
figures/service_per_bene_OP.png: .created-dirs\
	./derived_data/OP_Musculoskeletal.csv\
	Services_per_bene_by_region.R
	Rscript Services_per_bene_by_region.R
	
figures/services_USmap2016.png figures/services_USmap2017.png figures/services_USmap2018.png figures/services_USmap2019.png figures/services_USmap2020.png figures/services_USmap2021.png: .created-dirs\
	./derived_data/OP_Musculoskeletal.csv\
	Services_per_bene_map.R
	Rscript Services_per_bene_map.R
	
figures/corrplot_image.png: .created-dirs\
	./derived_data/OP_utilization.csv\
	Correlation.R
	Rscript Correlation.R
	
figures/ROC_curve.png: .created-dirs\
	./derived_data/OP_utilization.csv\
	Logistic_regression.R
	Rscript Logistic_regression.R
	
report.html: figures/total_cost_OP.png figures/total_cost_perdisc_OP.png figures/Top10_APC.png figures/service_per_bene_OP.png figures/services_USmap2016.png figures/services_USmap2017.png figures/services_USmap2018.png figures/services_USmap2019.png figures/services_USmap2020.png figures/services_USmap2021.png figures/corrplot_image.png figures/ROC_curve.png
	R -e "rmarkdown::render(\"Report.Rmd\", output_format = \"html_document\")"
