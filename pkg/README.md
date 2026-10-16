
<!-- README.md is generated from README.Rmd. Please edit that file -->

# collegeScorecard

<!-- badges: start -->

<!-- badges: end -->

collegeScorecard provides a tidied subset of the [US College Scorecard
dataset](https://collegescorecard.ed.gov/data/), containing
institutional characteristics, enrollment, student aid, costs, and
student outcomes at institutions of higher education in the United
States.

## Installation

Install collegeScorecard from CRAN with:

``` r
install.packages("collegeScorecard")
```

Or install the development version from r-universe

``` r
install.packages(
  "collegeScorecard",
  repos = c("https://gadenbuie.r-universe.dev", "https://cloud.r-project.org")
)
```

or from Github

``` r
# install.packages("pak")
pak::pak("gadenbuie/scorecard-db/pkg")
```

## Example

Loading collegeScorecard gives you access to `school` and `scorecard`
tables, which are tibbles with information about institutions and yearly
costs and admissions data, respectively.

``` r
library(collegeScorecard)
```

``` r
skimr::skim_tee(school)
#> ── Data Summary ────────────────────────
#>                            Values
#> Name                       data  
#> Number of rows             11465 
#> Number of columns          25    
#> _______________________          
#> Column type frequency:           
#>   character                5     
#>   factor                   7     
#>   logical                  10    
#>   numeric                  3     
#> ________________________         
#> Group variables            None  
#> 
#> ── Variable type: character ────────────────────────────────────────────────────
#>   skim_variable n_missing complete_rate min max empty n_unique whitespace
#> 1 name                  0         1       3  93     0    10687          0
#> 2 city                  0         1       3  23     0     2935          0
#> 3 state                 0         1       2   2     0       59          0
#> 4 zip                   0         1       5  10     0     8918          0
#> 5 url                5332         0.535  15 136     0     5204          0
#> 
#> ── Variable type: factor ───────────────────────────────────────────────────────
#>   skim_variable         n_missing complete_rate ordered n_unique
#> 1 deg_predominant            1066        0.907  FALSE          4
#> 2 deg_highest                1292        0.887  FALSE          4
#> 3 control                       1        1.000  FALSE          3
#> 4 locale_type                5860        0.489  FALSE          4
#> 5 locale_size                5860        0.489  FALSE          6
#> 6 adm_req_test              10744        0.0629 FALSE          4
#> 7 religious_affiliation     10641        0.0719 FALSE         60
#>   top_counts                                
#> 1 Cer: 5618, Bac: 2533, Ass: 1798, Gra: 450 
#> 2 Cer: 4291, Gra: 2559, Ass: 2104, Bac: 1219
#> 3 For: 6015, Non: 2799, Pub: 2650           
#> 4 Cit: 2717, Sub: 1607, Tow: 757, Rur: 524  
#> 5 Lar: 2665, Sma: 834, Mid: 825, Dis: 516   
#> 6 Not: 406, Req: 153, Rec: 122, Con: 40     
#> 7 Rom: 223, Uni: 83, Bap: 54, Pre: 50       
#> 
#> ── Variable type: logical ──────────────────────────────────────────────────────
#>    skim_variable    n_missing complete_rate    mean count              
#>  1 is_hbcu               5789         0.495 0.0176  FAL: 5576, TRU: 100
#>  2 is_pbi                5789         0.495 0.0115  FAL: 5611, TRU: 65 
#>  3 is_annhi              5789         0.495 0.00300 FAL: 5659, TRU: 17 
#>  4 is_tribal             5789         0.495 0.00617 FAL: 5641, TRU: 35 
#>  5 is_aanapii            5789         0.495 0.0365  FAL: 5469, TRU: 207
#>  6 is_hsi                5789         0.495 0.106   FAL: 5074, TRU: 602
#>  7 is_nanti              5789         0.495 0.00599 FAL: 5642, TRU: 34 
#>  8 is_only_men           5789         0.495 0.0106  FAL: 5616, TRU: 60 
#>  9 is_only_women         5789         0.495 0.00529 FAL: 5646, TRU: 30 
#> 10 is_only_distance      2900         0.747 0.00829 FAL: 8494, TRU: 71 
#> 
#> ── Variable type: numeric ──────────────────────────────────────────────────────
#>   skim_variable n_missing complete_rate      mean         sd       p0      p25
#> 1 id                    0         1     2698142.  8635097.   100654   183859  
#> 2 latitude           5857         0.489      37.3       5.86    -14.3     33.9
#> 3 longitude          5857         0.489     -90.4      18.2    -171.     -97.5
#>        p50      p75       p100 hist 
#> 1 372772   457679   49664501   ▇▁▁▁▁
#> 2     38.6     41.2       71.3 ▁▁▆▇▁
#> 3    -86.4    -78.9      171.  ▂▇▁▁▁
```

``` r
skimr::skim_tee(scorecard)
#> ── Data Summary ────────────────────────
#>                            Values
#> Name                       data  
#> Number of rows             200699
#> Number of columns          24    
#> _______________________          
#> Column type frequency:           
#>   character                1     
#>   numeric                  23    
#> ________________________         
#> Group variables            None  
#> 
#> ── Variable type: character ────────────────────────────────────────────────────
#>   skim_variable n_missing complete_rate min max empty n_unique whitespace
#> 1 academic_year         0             1   7   7     0       30          0
#> 
#> ── Variable type: numeric ──────────────────────────────────────────────────────
#>    skim_variable             n_missing complete_rate        mean          sd
#>  1 id                                0         1     1274554.    5631724.   
#>  2 n_undergrads                  28055         0.860    2316.       5205.   
#>  3 cost_tuition_in              100818         0.498   12800.      11530.   
#>  4 cost_tuition_out             103352         0.485   15347.      10940.   
#>  5 cost_books                   103638         0.484    1112.        628.   
#>  6 cost_room_board_on           149774         0.254    8268.       3558.   
#>  7 cost_room_board_off          108735         0.458    8285.       3696.   
#>  8 cost_avg                     112476         0.440   16006.       8418.   
#>  9 cost_avg_income_0_30k        113458         0.435   14123.       7844.   
#> 10 cost_avg_income_30_48k       124364         0.380   14808.       7889.   
#> 11 cost_avg_income_48_75k       129612         0.354   16847.       7896.   
#> 12 cost_avg_income_75_110k      140130         0.302   19335.       8010.   
#> 13 cost_avg_income_110k_plus    149652         0.254   21643.       9263.   
#> 14 amnt_earnings_med_10y        161040         0.198   35245.      15056.   
#> 15 rate_completion              148362         0.261       0.338       0.237
#> 16 rate_admissions              139752         0.304       0.700       0.211
#> 17 score_sat_avg                169085         0.158    1083.        138.   
#> 18 score_act_p25                172362         0.141      20.3         3.82 
#> 19 score_act_p75                172368         0.141      25.6         3.63 
#> 20 score_sat_verbal_p25         172407         0.141     489.         74.3  
#> 21 score_sat_verbal_p75         172406         0.141     595.         70.2  
#> 22 score_sat_math_p25           172273         0.142     489.         77.3  
#> 23 score_sat_math_p75           172275         0.142     597.         73.3  
#>         p0        p25        p50        p75     p100 hist 
#>  1  100654 165033     214795     418560     49664501 ▇▁▁▁▁
#>  2       0    118        498       2073       253594 ▇▁▁▁▁
#>  3       0   4170       9685      17148        74787 ▇▂▁▁▁
#>  4       0   7610      12544      19356.       74787 ▇▃▁▁▁
#>  5       0    800       1020       1386        28000 ▇▁▁▁▁
#>  6       0   5600       7811      10446        34336 ▆▇▁▁▁
#>  7       0   5840       7662.     10110       106962 ▇▁▁▁▁
#>  8 -103168   9415      15419      21310.      115636 ▁▁▇▁▁
#>  9 -117833   7992      13418      19180       115636 ▁▁▇▂▁
#> 10  -44508   8609      14085      19815       113384 ▁▇▃▁▁
#> 11  -17804  10683      16278      21788.      113427 ▂▇▁▁▁
#> 12  -18045  13169      18986      24421       114298 ▁▇▁▁▁
#> 13  -17487  14571      20674      26828.      113314 ▁▇▁▁▁
#> 14    8400  25500      32900      42000       250000 ▇▁▁▁▁
#> 15       0      0.150      0.308      0.5          1 ▇▇▅▃▁
#> 16       0      0.572      0.729      0.858        1 ▁▂▅▇▇
#> 17     514    990       1064       1155         1599 ▁▂▇▂▁
#> 18       1     18         20         22           35 ▁▁▇▃▁
#> 19       2     23         25         28           36 ▁▁▂▇▂
#> 20     100    440        480        530          799 ▁▁▇▃▁
#> 21     100    550        590        640          800 ▁▁▂▇▂
#> 22     100    440        480        530          799 ▁▁▇▃▁
#> 23     100    550        590        640          800 ▁▁▂▇▂
```

## Interpreting costs, completion, and coverage

- `cost_avg` and `cost_avg_income_*` are average **net prices**, not
  costs of attendance. They use the private-institution value when
  available and otherwise the public-institution value.
- `rate_completion` (`C100_4`) measures completion within 100% of normal
  time at four-year institutions for first-time, full-time students.
- Only institutions whose most recent record has `OPEFLAG = 1` (Title IV
  participants) are included. Branch campuses with `OPEFLAG = 2`,
  deferment-only institutions, and nonparticipating institutions are
  excluded from both datasets.
- The Most Recent Institution bulk file can use different academic years
  for different metrics. It is not equivalent to selecting one
  `academic_year` from `scorecard`.

The help documentation of each dataset provides a short description of
each column and the source of the data. Additional information is
included in the packaged data dictionary.

``` r
readRDS(system.file("scorecard-data-dictionary.rds", package = "collegeScorecard"))
#> $info
#> # A tibble: 3,305 × 11
#>    name_of_data_element        dev_category developer_friendly_n…¹ api_data_type
#>    <chr>                       <chr>        <chr>                  <chr>        
#>  1 Unit ID for institution     root         id                     integer      
#>  2 8-digit OPE ID for institu… root         ope8_id                string       
#>  3 6-digit OPE ID for institu… root         ope6_id                string       
#>  4 Institution name            school       name                   autocomplete 
#>  5 City                        school       city                   autocomplete 
#>  6 State postcode              school       state                  string       
#>  7 ZIP code                    school       zip                    string       
#>  8 Accreditor for institution  school       accreditor             string       
#>  9 URL for institution's home… school       school_url             string       
#> 10 URL for institution's net … school       price_calculator_url   string       
#> # ℹ 3,295 more rows
#> # ℹ abbreviated name: ¹​developer_friendly_name
#> # ℹ 7 more variables: data_type <chr>, index <chr>, variable_name <chr>,
#> #   source <chr>, shown_use_on_site <chr>, notes <chr>, has_labels <lgl>
#> 
#> $labels
#> # A tibble: 293 × 4
#>    variable_name value label                                     notes
#>    <chr>         <chr> <chr>                                     <chr>
#>  1 MAIN          0     Not main campus                           <NA> 
#>  2 MAIN          1     Main campus                               <NA> 
#>  3 PREDDEG       0     Not classified                            <NA> 
#>  4 PREDDEG       1     Predominantly certificate-degree granting <NA> 
#>  5 PREDDEG       2     Predominantly associate's-degree granting <NA> 
#>  6 PREDDEG       3     Predominantly bachelor's-degree granting  <NA> 
#>  7 PREDDEG       4     Entirely graduate-degree granting         <NA> 
#>  8 HIGHDEG       0     Non-degree-granting                       <NA> 
#>  9 HIGHDEG       1     Certificate degree                        <NA> 
#> 10 HIGHDEG       2     Associate degree                          <NA> 
#> # ℹ 283 more rows
```
