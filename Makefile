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
	
derived_data/Demographics.csv derived_data/State_price.csv: .created-dirs\
	./Data\ source/state_stdprices.csv\
  ./Data\ source/Pop_by_Age_Sex.csv\
  ./Data\ source/Pop_by_Race.csv\
  ./Data\ source/Pop_by_Income.csv\
  Pre_process4.R
	Rscript Pre_process4.R
	
derived_data/In-patient_Geo.csv derived_data/Out-patient_Geo.csv: .created-dirs\
  ./derived_data/In-patient.csv\
  ./derived_data/Out-patient.csv\
  Derive_regions.R
	Rscript Derive_regions.R
	
figures/total_cost_IP.png figures/total_cost_OP.png: .created-dirs\
  ./derived_data/In-patient_Geo.csv\
  ./derived_data/Out-patient_Geo.csv\
  Plot_total_cost.R
	Rscript Plot_total_cost.R
	
figures/total_cost_perdisc_IP.png figures/total_cost_perdisc_OP.png: .created-dirs\
  ./derived_data/In-patient_Geo.csv\
  ./derived_data/Out-patient_Geo.csv\
  Plot_total_cost_per_discharge.R
	Rscript Plot_total_cost_per_discharge.R
	
figures/Top10_APC.png: .created-dirs\
  ./derived_data/Out-patient_Geo.csv\
  Top10_APC.R
	Rscript Top10_APC.R

derived_data/OP_wide: .created-dirs\
	./derived_data/Out-patient_Geo.csv\
  ./derived_data/State_price.csv\
  ./derived_data/Demographics.csv\
  PCA_preprocess.R
	Rscript PCA_preprocess.R

figures/PCA_Region2.png figures/PCA_Region5.png figures/PCA.png: .created-dirs\
  ./derived_data/OP_wide.csv\
  PCA.R
	Rscript PCA.R
	
figures/cluster_plot.png: .created-dirs\
  ./derived_data/OP_wide.csv\
  Clustering.R
	Rscript Clustering.R