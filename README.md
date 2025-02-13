# College Scorecard Database


Turn [College Scorecard data](https://collegescorecard.ed.gov/data/)
into parquet files, a SQLite database, CSV and RDS (R data storage)
files.

The code in this repository is licensed under [the MIT
License](https://mit-license.org/). The data files are in the public
domain.

## Dependencies and Setup

This project uses [renv](https://rstudio.github.io/renv/) to manage
dependencies. To install the dependencies, run `renv::restore()` in the
R console on R 4.4.1.

``` r
renv::restore()
```

## Instructions

We use [targets](https://docs.ropensci.org/targets/) to manage the data
prep pipeline. To download the source data and build all outputs, run
the following in the R console:

``` r
targets::tar_make()
```

To update the data, invalidate the `url_data_zip` target –
`targets::tar_invalidate("url_data_zip")` – and run
`targets::tar_make()` again.

### Raw College Scorecard Data

The raw College Scorecard data is available as a set of parquet files in
`data/parquet`. The complete scorecard dataset is stored as a set of
parquet files in `data/parquet/merged`. Two informational tables contain
the data dictionary (`data/parquet/dd_info.parquet`) and the variable
labels (`data/parquet/dd_labels.parquet`) for categorical variables in
the scorecard dataset.

``` r
scorecard <- targets::tar_read("path_data_full_merged") |> arrow::read_dataset()
dd_info   <- targets::tar_read("path_data_full_info")   |> arrow::read_parquet()
dd_labels <- targets::tar_read("path_data_full_labels") |> arrow::read_parquet()
```

### Tidy College Scorecard Tables

The most approachable tables are the `school_tidy` and `scorecard_tidy`
targets.

``` r
school_tidy <- targets::tar_read("school_tidy")
skimr::skim_tee(school_tidy)
```

    ── Data Summary ────────────────────────
                               Values
    Name                       data  
    Number of rows             11300 
    Number of columns          25    
    _______________________          
    Column type frequency:           
      character                5     
      factor                   7     
      logical                  10    
      numeric                  3     
    ________________________         
    Group variables            None  

    ── Variable type: character ────────────────────────────────────────────────────
      skim_variable n_missing complete_rate min max empty n_unique whitespace
    1 name                  0         1       3  93     0    10525          0
    2 city                  0         1       3  23     0     2915          0
    3 state                 0         1       2   2     0       59          0
    4 zip                   0         1       5  10     0     8757          0
    5 url                4943         0.563  15 123     0     5435          0

    ── Variable type: factor ───────────────────────────────────────────────────────
      skim_variable         n_missing complete_rate ordered n_unique
    1 deg_predominant             998        0.912  FALSE          4
    2 deg_highest                1193        0.894  FALSE          4
    3 control                       1        1.00   FALSE          3
    4 locale_type                5415        0.521  FALSE          4
    5 locale_size                5415        0.521  FALSE          6
    6 adm_req_test               8685        0.231  FALSE          4
    7 religious_affiliation     10449        0.0753 FALSE         60
      top_counts                                
    1 Cer: 5483, Bac: 2549, Ass: 1819, Gra: 451 
    2 Cer: 4287, Gra: 2517, Ass: 2111, Bac: 1192
    3 For: 5908, Non: 2760, Pub: 2631           
    4 Cit: 2812, Sub: 1750, Tow: 822, Rur: 501  
    5 Lar: 2809, Sma: 887, Mid: 866, Dis: 508   
    6 Con: 1205, Not: 1015, Req: 273, Rec: 122  
    7 Rom: 232, Uni: 85, Bap: 56, Pre: 54       

    ── Variable type: logical ──────────────────────────────────────────────────────
       skim_variable    n_missing complete_rate    mean count              
     1 is_hbcu               5412         0.521 0.0168  FAL: 5789, TRU: 99 
     2 is_pbi                5412         0.521 0.0105  FAL: 5826, TRU: 62 
     3 is_annhi              5412         0.521 0.00272 FAL: 5872, TRU: 16 
     4 is_tribal             5412         0.521 0.00594 FAL: 5853, TRU: 35 
     5 is_aanapii            5412         0.521 0.0350  FAL: 5682, TRU: 206
     6 is_hsi                5412         0.521 0.0909  FAL: 5353, TRU: 535
     7 is_nanti              5412         0.521 0.00543 FAL: 5856, TRU: 32 
     8 is_only_men           5412         0.521 0.0102  FAL: 5828, TRU: 60 
     9 is_only_women         5412         0.521 0.00510 FAL: 5858, TRU: 30 
    10 is_only_distance      2832         0.749 0.00709 FAL: 8408, TRU: 60 

    ── Variable type: numeric ──────────────────────────────────────────────────────
      skim_variable n_missing complete_rate      mean         sd       p0      p25
    1 id                    0         1     2550768.  8357052.   100654   182632. 
    2 latitude           5412         0.521      37.3       5.87    -14.3     33.9
    3 longitude          5412         0.521     -90.4      18.2    -171.     -97.5
           p50      p75       p100 hist 
    1 367422   455666.  49664501   ▇▁▁▁▁
    2     38.6     41.2       71.3 ▁▁▆▇▁
    3    -86.3    -78.9      171.  ▂▇▁▁▁

``` r
scorecard_tidy <- targets::tar_read("scorecard_tidy")
skimr::skim_tee(scorecard_tidy)
```

    ── Data Summary ────────────────────────
                               Values
    Name                       data  
    Number of rows             183306
    Number of columns          23    
    _______________________          
    Column type frequency:           
      character                1     
      logical                  2     
      numeric                  20    
    ________________________         
    Group variables            None  

    ── Variable type: character ────────────────────────────────────────────────────
      skim_variable n_missing complete_rate min max empty n_unique whitespace
    1 academic_year         0             1   7   7     0       27          0

    ── Variable type: logical ──────────────────────────────────────────────────────
      skim_variable    n_missing complete_rate mean count
    1 cost_med_similar    183306             0  NaN ": " 
    2 cost_med_overall    183306             0  NaN ": " 

    ── Variable type: numeric ──────────────────────────────────────────────────────
       skim_variable             n_missing complete_rate        mean          sd
     1 id                                0       1       1163825.    5311085.   
     2 n_undergrads                  20563       0.888      2285.       5101.   
     3 cost_avg                     104675       0.429     15809.       8216.   
     4 cost_avg_income_0_30k        105507       0.424     13996.       7669.   
     5 cost_avg_income_30_48k       115448       0.370     14736.       7723.   
     6 cost_avg_income_48_75k       120294       0.344     16807.       7750.   
     7 cost_avg_income_75_110k      129900       0.291     19224.       7843.   
     8 cost_avg_income_110k_plus    138593       0.244     21352.       9036.   
     9 amnt_earnings_med_10y        143433       0.218     35228.      15046.   
    10 rate_completion              134721       0.265         0.333       0.237
    11 rate_admissions              181562       0.00951       0.722       0.221
    12 score_act_p25                156788       0.145        20.2         3.69 
    13 score_act_p50                182314       0.00541      24.5         4.56 
    14 score_act_p75                156794       0.145        25.4         3.55 
    15 score_sat_verbal_p25         156906       0.144       484.         72.3  
    16 score_sat_verbal_p50         182311       0.00543     587.         71.6  
    17 score_sat_verbal_p75         156905       0.144       592.         69.3  
    18 score_sat_math_p25           156771       0.145       486.         75.7  
    19 score_sat_math_p50           182311       0.00543     580.         78.8  
    20 score_sat_math_p75           156773       0.145       594.         72.3  
                 p0        p25        p50        p75     p100 hist 
     1  100654      164562     213987     416670     49664501 ▇▁▁▁▁
     2       0         117        490       2050       253594 ▇▁▁▁▁
     3 -103168        9319      15281      21090.      112050 ▁▁▇▁▁
     4 -117833        7952      13336      19036.      111962 ▁▁▇▂▁
     5  -44508        8618.     14055      19740       113384 ▁▇▃▁▁
     6  -17804       10711.     16289      21716       113427 ▂▇▁▁▁
     7  -18045       13149.     18933      24285.      114298 ▁▇▁▁▁
     8  -17487       14415      20448      26533       113314 ▁▇▁▁▁
     9    8400       25400      32900      42000       250000 ▇▁▁▁▁
    10       0           0.145      0.3        0.498        1 ▇▇▅▂▁
    11       0.0106      0.612      0.773      0.889        1 ▁▁▂▆▇
    12       1          18         20         22           35 ▁▁▇▃▁
    13       5          21         24         27           35 ▁▁▇▆▃
    14       2          23         25         27           36 ▁▁▂▇▂
    15     100         440        480        520          799 ▁▁▇▃▁
    16     380         540        580        630          760 ▁▅▇▅▂
    17     100         540        590        630          800 ▁▁▂▇▂
    18     100         440        475        520          799 ▁▁▇▃▁
    19     310         530        570        620          800 ▁▂▇▃▁
    20     100         550        588        630          800 ▁▁▂▇▂

For ease of use, the variables in `school_tidy` and `scorecard_tidy`
have been renamed from the original names. I don’t yet have a mapping
back to the original names, but you can reference the `data_dictionary`
target to see information about the original names.

``` r
data_dictionary <- targets::tar_read("data_dictionary")
head(data_dictionary$info, 10)
```

    # A tibble: 10 × 11
       name_of_data_element        dev_category developer_friendly_n…¹ api_data_type
       <chr>                       <chr>        <chr>                  <chr>        
     1 Unit ID for institution     root         id                     integer      
     2 8-digit OPE ID for institu… root         ope8_id                string       
     3 6-digit OPE ID for institu… root         ope6_id                string       
     4 Institution name            school       name                   autocomplete 
     5 City                        school       city                   autocomplete 
     6 State postcode              school       state                  string       
     7 ZIP code                    school       zip                    string       
     8 Accreditor for institution  school       accreditor             string       
     9 URL for institution's home… school       school_url             string       
    10 URL for institution's net … school       price_calculator_url   string       
    # ℹ abbreviated name: ¹​developer_friendly_name
    # ℹ 7 more variables: data_type <chr>, index <chr>, variable_name <chr>,
    #   source <chr>, shown_use_on_site <chr>, notes <chr>, has_labels <lgl>
