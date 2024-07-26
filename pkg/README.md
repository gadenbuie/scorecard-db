
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
#> Number of rows             11300 
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
#> 1 name                  0         1       3  93     0    10525          0
#> 2 city                  0         1       3  23     0     2915          0
#> 3 state                 0         1       2   2     0       59          0
#> 4 zip                   0         1       5  10     0     8757          0
#> 5 url                4943         0.563  15 123     0     5435          0
#> 
#> ── Variable type: factor ───────────────────────────────────────────────────────
#>   skim_variable         n_missing complete_rate ordered n_unique
#> 1 deg_predominant             998        0.912  FALSE          4
#> 2 deg_highest                1193        0.894  FALSE          4
#> 3 control                       1        1.00   FALSE          3
#> 4 locale_type                5415        0.521  FALSE          4
#> 5 locale_size                5415        0.521  FALSE          6
#> 6 adm_req_test               8685        0.231  FALSE          4
#> 7 religious_affiliation     10449        0.0753 FALSE         60
#>   top_counts                                
#> 1 Cer: 5483, Bac: 2549, Ass: 1819, Gra: 451 
#> 2 Cer: 4287, Gra: 2517, Ass: 2111, Bac: 1192
#> 3 For: 5908, Non: 2760, Pub: 2631           
#> 4 Cit: 2812, Sub: 1750, Tow: 822, Rur: 501  
#> 5 Lar: 2809, Sma: 887, Mid: 866, Dis: 508   
#> 6 Con: 1205, Not: 1015, Req: 273, Rec: 122  
#> 7 Rom: 232, Uni: 85, Bap: 56, Pre: 54       
#> 
#> ── Variable type: logical ──────────────────────────────────────────────────────
#>    skim_variable    n_missing complete_rate    mean count              
#>  1 is_hbcu               5412         0.521 0.0168  FAL: 5789, TRU: 99 
#>  2 is_pbi                5412         0.521 0.0105  FAL: 5826, TRU: 62 
#>  3 is_annhi              5412         0.521 0.00272 FAL: 5872, TRU: 16 
#>  4 is_tribal             5412         0.521 0.00594 FAL: 5853, TRU: 35 
#>  5 is_aanapii            5412         0.521 0.0350  FAL: 5682, TRU: 206
#>  6 is_hsi                5412         0.521 0.0909  FAL: 5353, TRU: 535
#>  7 is_nanti              5412         0.521 0.00543 FAL: 5856, TRU: 32 
#>  8 is_only_men           5412         0.521 0.0102  FAL: 5828, TRU: 60 
#>  9 is_only_women         5412         0.521 0.00510 FAL: 5858, TRU: 30 
#> 10 is_only_distance      2832         0.749 0.00709 FAL: 8408, TRU: 60 
#> 
#> ── Variable type: numeric ──────────────────────────────────────────────────────
#>   skim_variable n_missing complete_rate      mean         sd       p0      p25
#> 1 id                    0         1     2550768.  8357052.   100654   182632. 
#> 2 latitude           5412         0.521      37.3       5.87    -14.3     33.9
#> 3 longitude          5412         0.521     -90.4      18.2    -171.     -97.5
#>        p50      p75       p100 hist 
#> 1 367422   455666.  49664501   ▇▁▁▁▁
#> 2     38.6     41.2       71.3 ▁▁▆▇▁
#> 3    -86.3    -78.9      171.  ▂▇▁▁▁
```

``` r
skimr::skim_tee(scorecard)
#> ── Data Summary ────────────────────────
#>                            Values
#> Name                       data  
#> Number of rows             183306
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
#> 1 academic_year         0             1   7   7     0       27          0
#> 
#> ── Variable type: numeric ──────────────────────────────────────────────────────
#>    skim_variable             n_missing complete_rate        mean          sd
#>  1 id                                0         1     1163825.    5311085.   
#>  2 n_undergrads                  20563         0.888    2285.       5101.   
#>  3 cost_tuition_in               90259         0.508   12429.      10992.   
#>  4 cost_tuition_out              92793         0.494   14882.      10390.   
#>  5 cost_books                    92332         0.496    1101.        623.   
#>  6 cost_room_board_on           136207         0.257    7961.       3322.   
#>  7 cost_room_board_off           97476         0.468    7963.       3392.   
#>  8 cost_avg                     104675         0.429   15809.       8216.   
#>  9 cost_avg_income_0_30k        105507         0.424   13996.       7669.   
#> 10 cost_avg_income_30_48k       115448         0.370   14736.       7723.   
#> 11 cost_avg_income_48_75k       120294         0.344   16807.       7750.   
#> 12 cost_avg_income_75_110k      129900         0.291   19224.       7843.   
#> 13 cost_avg_income_110k_plus    138593         0.244   21352.       9036.   
#> 14 amnt_earnings_med_10y        143433         0.218   35228.      15046.   
#> 15 rate_completion              134721         0.265       0.333       0.237
#> 16 rate_admissions              126465         0.310       0.698       0.210
#> 17 score_sat_avg                153731         0.161    1076.        135.   
#> 18 score_act_p25                156788         0.145      20.2         3.69 
#> 19 score_act_p75                156794         0.145      25.4         3.55 
#> 20 score_sat_verbal_p25         156906         0.144     484.         72.3  
#> 21 score_sat_verbal_p75         156905         0.144     592.         69.3  
#> 22 score_sat_math_p25           156771         0.145     486.         75.7  
#> 23 score_sat_math_p75           156773         0.145     594.         72.3  
#>         p0        p25        p50        p75     p100 hist 
#>  1  100654 164562     213987     416670     49664501 ▇▁▁▁▁
#>  2       0    117        490       2050       253594 ▇▁▁▁▁
#>  3       0   4053       9556      16888        74787 ▇▂▁▁▁
#>  4       0   7475      12336      18810        74787 ▇▃▁▁▁
#>  5       0    800       1000       1354.       28000 ▇▁▁▁▁
#>  6       0   5496       7560      10008        27000 ▃▇▂▁▁
#>  7       0   5725       7474       9728       106962 ▇▁▁▁▁
#>  8 -103168   9319      15281      21090.      112050 ▁▁▇▁▁
#>  9 -117833   7952      13336      19036.      111962 ▁▁▇▂▁
#> 10  -44508   8618.     14055      19740       113384 ▁▇▃▁▁
#> 11  -17804  10711.     16289      21716       113427 ▂▇▁▁▁
#> 12  -18045  13149.     18933      24285.      114298 ▁▇▁▁▁
#> 13  -17487  14415      20448      26533       113314 ▁▇▁▁▁
#> 14    8400  25400      32900      42000       250000 ▇▁▁▁▁
#> 15       0      0.145      0.3        0.498        1 ▇▇▅▂▁
#> 16       0      0.569      0.725      0.854        1 ▁▂▅▇▇
#> 17     514    989       1056       1145         1599 ▁▂▇▂▁
#> 18       1     18         20         22           35 ▁▁▇▃▁
#> 19       2     23         25         27           36 ▁▁▂▇▂
#> 20     100    440        480        520          799 ▁▁▇▃▁
#> 21     100    540        590        630          800 ▁▁▂▇▂
#> 22     100    440        475        520          799 ▁▁▇▃▁
#> 23     100    550        588        630          800 ▁▁▂▇▂
```

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
