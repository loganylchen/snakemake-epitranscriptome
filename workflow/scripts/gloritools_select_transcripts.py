import sys
import pandas as pd
import os

import re
from collections import defaultdict,OrderedDict
import pandas as pd


sys.stdout = open(snakemake.log.log,'w') 
sys.stderr= open(snakemake.log.err, 'w')

annotate_df = pd.read_csv(snakemake.input.anno,sep='\t')
output_list=snakemake.output.longest_transcript

os.makedirs(os.path.dirname(output_list))

print('selecting longest transcripts')
# NF564	ENST00000339282	19	-	12525373	12551482	12526449,12528304,12528570,12551330	12527916,12528364,12528696,12551332	4	12525373,12528304,12528570,12551330	12527916,12528364,12528696,12551482	2885	ENSG00000249709	protein_coding	12	1659
# ZNF564	ENST00000427105	19	-	12527858	12551467	12528683,12550463,12551330	12528696,12550652,12551332	5	12527858,12528304,12528570,12550463,12551330	12527916,12528364,12528696,12550652,12551467	575	ENSG00000249709	nonsense_mediated_decay	1	207
# ZNF564	ENST00000596193	19	-	12527907	12551542	12527907,12528304,12528570	12527916,12528364,12528603	5	12527907,12528304,12528570,12541425,12551330	12527916,12528364,12528696,12541537,12551542	524	ENSG00000249709	protein_coding	1	105
# ZNF564	ENST00000416136	19	-	12548713	12551434	12548803,12551330	12548862,12551332	2	12548713,12551330	12548862,12551434	255	ENSG00000249709	protein_coding	1	63
# ZNF564	ENST00000465410	19	-	12550242	12551432	.	.	2	12550242,12551330	12550652,12551432	514	ENSG00000249709	retained_intron	1	0


selected_df = annotate_df.sort_values('transcript_length', ascending=False).drop_duplicates('gene_id')
selected_df.to_csv(f'{output_list}.tsv',sep='\t',index=False)
selected_df['transcript_id'].to_csv(output_list,sep='\t',index=False,header=False)
