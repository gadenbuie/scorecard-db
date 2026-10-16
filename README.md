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

Run the pipeline regression tests from the repository root with:

``` bash
Rscript tests/testthat.R
```

These tests use small local fixtures and do not download Scorecard data.

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
    Number of rows             11465 
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
    1 name                  0         1       3  93     0    10687          0
    2 city                  0         1       3  23     0     2935          0
    3 state                 0         1       2   2     0       59          0
    4 zip                   0         1       5  10     0     8918          0
    5 url                5332         0.535  15 136     0     5204          0

    ── Variable type: factor ───────────────────────────────────────────────────────
      skim_variable         n_missing complete_rate ordered n_unique
    1 deg_predominant            1066        0.907  FALSE          4
    2 deg_highest                1292        0.887  FALSE          4
    3 control                       1        1.000  FALSE          3
    4 locale_type                5860        0.489  FALSE          4
    5 locale_size                5860        0.489  FALSE          6
    6 adm_req_test              10744        0.0629 FALSE          4
    7 religious_affiliation     10641        0.0719 FALSE         60
      top_counts                                
    1 Cer: 5618, Bac: 2533, Ass: 1798, Gra: 450 
    2 Cer: 4291, Gra: 2559, Ass: 2104, Bac: 1219
    3 For: 6015, Non: 2799, Pub: 2650           
    4 Cit: 2717, Sub: 1607, Tow: 757, Rur: 524  
    5 Lar: 2665, Sma: 834, Mid: 825, Dis: 516   
    6 Not: 406, Req: 153, Rec: 122, Con: 40     
    7 Rom: 223, Uni: 83, Bap: 54, Pre: 50       

    ── Variable type: logical ──────────────────────────────────────────────────────
       skim_variable    n_missing complete_rate    mean count              
     1 is_hbcu               5789         0.495 0.0176  FAL: 5576, TRU: 100
     2 is_pbi                5789         0.495 0.0115  FAL: 5611, TRU: 65 
     3 is_annhi              5789         0.495 0.00300 FAL: 5659, TRU: 17 
     4 is_tribal             5789         0.495 0.00617 FAL: 5641, TRU: 35 
     5 is_aanapii            5789         0.495 0.0365  FAL: 5469, TRU: 207
     6 is_hsi                5789         0.495 0.106   FAL: 5074, TRU: 602
     7 is_nanti              5789         0.495 0.00599 FAL: 5642, TRU: 34 
     8 is_only_men           5789         0.495 0.0106  FAL: 5616, TRU: 60 
     9 is_only_women         5789         0.495 0.00529 FAL: 5646, TRU: 30 
    10 is_only_distance      2900         0.747 0.00829 FAL: 8494, TRU: 71 

    ── Variable type: numeric ──────────────────────────────────────────────────────
      skim_variable n_missing complete_rate      mean         sd       p0      p25
    1 id                    0         1     2698142.  8635097.   100654   183859  
    2 latitude           5857         0.489      37.3       5.86    -14.3     33.9
    3 longitude          5857         0.489     -90.4      18.2    -171.     -97.5
           p50      p75       p100 hist 
    1 372772   457679   49664501   ▇▁▁▁▁
    2     38.6     41.2       71.3 ▁▁▆▇▁
    3    -86.4    -78.9      171.  ▂▇▁▁▁

``` r
scorecard_tidy <- targets::tar_read("scorecard_tidy")
skimr::skim_tee(scorecard_tidy)
```

    ── Data Summary ────────────────────────
                               Values
    Name                       data  
    Number of rows             200699
    Number of columns          28    
    _______________________          
    Column type frequency:           
      character                1     
      numeric                  27    
    ________________________         
    Group variables            None  

    ── Variable type: character ────────────────────────────────────────────────────
      skim_variable n_missing complete_rate min max empty n_unique whitespace
    1 academic_year         0             1   7   7     0       30          0

    ── Variable type: numeric ──────────────────────────────────────────────────────
       skim_variable                 n_missing complete_rate        mean          sd
     1 id                                    0         1     1274554.    5631724.   
     2 n_undergrads                      28055         0.860    2316.       5205.   
     3 cost_tuition_in                  100818         0.498   12800.      11530.   
     4 cost_tuition_out                 103352         0.485   15347.      10940.   
     5 cost_books                       103638         0.484    1112.        628.   
     6 cost_room_board_on               149774         0.254    8268.       3558.   
     7 cost_room_board_off              108735         0.458    8285.       3696.   
     8 cost_attendance_academic_year    142598         0.289   25988.      14965.   
     9 cost_attendance_program_year     165603         0.175   20680.       7708.   
    10 cost_avg                         112476         0.440   16006.       8418.   
    11 cost_avg_income_0_30k            113458         0.435   14123.       7844.   
    12 cost_avg_income_30_48k           124364         0.380   14808.       7889.   
    13 cost_avg_income_48_75k           129612         0.354   16847.       7896.   
    14 cost_avg_income_75_110k          140130         0.302   19335.       8010.   
    15 cost_avg_income_110k_plus        149652         0.254   21643.       9263.   
    16 amnt_earnings_med_10y            161040         0.198   35245.      15056.   
    17 rate_completion                  148362         0.261       0.338       0.237
    18 rate_completion_150_4yr          140972         0.298       0.494       0.213
    19 rate_completion_150_lt4yr        105143         0.476       0.555       0.264
    20 rate_admissions                  139752         0.304       0.700       0.211
    21 score_sat_avg                    169085         0.158    1083.        138.   
    22 score_act_p25                    172362         0.141      20.3         3.82 
    23 score_act_p75                    172368         0.141      25.6         3.63 
    24 score_sat_verbal_p25             172407         0.141     489.         74.3  
    25 score_sat_verbal_p75             172406         0.141     595.         70.2  
    26 score_sat_math_p25               172273         0.142     489.         77.3  
    27 score_sat_math_p75               172275         0.142     597.         73.3  
            p0        p25        p50        p75     p100 hist 
     1  100654 165033     214795     418560     49664501 ▇▁▁▁▁
     2       0    118        498       2073       253594 ▇▁▁▁▁
     3       0   4170       9685      17148        74787 ▇▂▁▁▁
     4       0   7610      12544      19356.       74787 ▇▃▁▁▁
     5       0    800       1020       1386        28000 ▇▁▁▁▁
     6       0   5600       7811      10446        34336 ▆▇▁▁▁
     7       0   5840       7662.     10110       106962 ▇▁▁▁▁
     8    3368  14189      22551      32786        96375 ▇▆▂▁▁
     9       0  15560.     19882.     24758.      120377 ▇▃▁▁▁
    10 -103168   9415      15419      21310.      115636 ▁▁▇▁▁
    11 -117833   7992      13418      19180       115636 ▁▁▇▂▁
    12  -44508   8609      14085      19815       113384 ▁▇▃▁▁
    13  -17804  10683      16278      21788.      113427 ▂▇▁▁▁
    14  -18045  13169      18986      24421       114298 ▁▇▁▁▁
    15  -17487  14571      20674      26828.      113314 ▁▇▁▁▁
    16    8400  25500      32900      42000       250000 ▇▁▁▁▁
    17       0      0.150      0.308      0.5          1 ▇▇▅▃▁
    18       0      0.346      0.491      0.639        1 ▂▆▇▅▂
    19       0      0.326      0.593      0.765        1 ▃▅▆▇▆
    20       0      0.572      0.729      0.858        1 ▁▂▅▇▇
    21     514    990       1064       1155         1599 ▁▂▇▂▁
    22       1     18         20         22           35 ▁▁▇▃▁
    23       2     23         25         28           36 ▁▁▂▇▂
    24     100    440        480        530          799 ▁▁▇▃▁
    25     100    550        590        640          800 ▁▁▂▇▂
    26     100    440        480        530          799 ▁▁▇▃▁
    27     100    550        590        640          800 ▁▁▂▇▂

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
