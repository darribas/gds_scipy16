
#  Spatial Clustering


```python
%matplotlib inline

import pandas as pd
```

    /home/dani/anaconda/envs/pydata/lib/python2.7/site-packages/matplotlib/font_manager.py:273: UserWarning: Matplotlib is building the font cache using fc-list. This may take a moment.
      warnings.warn('Matplotlib is building the font cache using fc-list. This may take a moment.')



```python
link = '/home/dani/Desktop/listings.csv'
db = pd.read_csv(link)
db.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 5835 entries, 0 to 5834
    Data columns (total 92 columns):
    id                                  5835 non-null int64
    listing_url                         5835 non-null object
    scrape_id                           5835 non-null int64
    last_scraped                        5835 non-null object
    name                                5835 non-null object
    summary                             5373 non-null object
    space                               4475 non-null object
    description                         5832 non-null object
    experiences_offered                 5835 non-null object
    neighborhood_overview               3572 non-null object
    notes                               2413 non-null object
    transit                             3492 non-null object
    thumbnail_url                       5542 non-null object
    medium_url                          5542 non-null object
    picture_url                         5835 non-null object
    xl_picture_url                      5542 non-null object
    host_id                             5835 non-null int64
    host_url                            5835 non-null object
    host_name                           5820 non-null object
    host_since                          5820 non-null object
    host_location                       5810 non-null object
    host_about                          3975 non-null object
    host_response_time                  4177 non-null object
    host_response_rate                  4177 non-null object
    host_acceptance_rate                3850 non-null object
    host_is_superhost                   5820 non-null object
    host_thumbnail_url                  5820 non-null object
    host_picture_url                    5820 non-null object
    host_neighbourhood                  4977 non-null object
    host_listings_count                 5820 non-null float64
    host_total_listings_count           5820 non-null float64
    host_verifications                  5835 non-null object
    host_has_profile_pic                5820 non-null object
    host_identity_verified              5820 non-null object
    street                              5835 non-null object
    neighbourhood                       4800 non-null object
    neighbourhood_cleansed              5835 non-null int64
    neighbourhood_group_cleansed        0 non-null float64
    city                                5835 non-null object
    state                               5835 non-null object
    zipcode                             5810 non-null float64
    market                              5835 non-null object
    smart_location                      5835 non-null object
    country_code                        5835 non-null object
    country                             5835 non-null object
    latitude                            5835 non-null float64
    longitude                           5835 non-null float64
    is_location_exact                   5835 non-null object
    property_type                       5835 non-null object
    room_type                           5835 non-null object
    accommodates                        5835 non-null int64
    bathrooms                           5789 non-null float64
    bedrooms                            5829 non-null float64
    beds                                5812 non-null float64
    bed_type                            5835 non-null object
    amenities                           5835 non-null object
    square_feet                         302 non-null float64
    price                               5835 non-null object
    weekly_price                        2227 non-null object
    monthly_price                       1717 non-null object
    security_deposit                    2770 non-null object
    cleaning_fee                        3587 non-null object
    guests_included                     5835 non-null int64
    extra_people                        5835 non-null object
    minimum_nights                      5835 non-null int64
    maximum_nights                      5835 non-null int64
    calendar_updated                    5835 non-null object
    has_availability                    5835 non-null object
    availability_30                     5835 non-null int64
    availability_60                     5835 non-null int64
    availability_90                     5835 non-null int64
    availability_365                    5835 non-null int64
    calendar_last_scraped               5835 non-null object
    number_of_reviews                   5835 non-null int64
    first_review                        3827 non-null object
    last_review                         3829 non-null object
    review_scores_rating                3789 non-null float64
    review_scores_accuracy              3776 non-null float64
    review_scores_cleanliness           3778 non-null float64
    review_scores_checkin               3778 non-null float64
    review_scores_communication         3778 non-null float64
    review_scores_location              3779 non-null float64
    review_scores_value                 3778 non-null float64
    requires_license                    5835 non-null object
    license                             1 non-null float64
    jurisdiction_names                  0 non-null float64
    instant_bookable                    5835 non-null object
    cancellation_policy                 5835 non-null object
    require_guest_profile_picture       5835 non-null object
    require_guest_phone_verification    5835 non-null object
    calculated_host_listings_count      5835 non-null int64
    reviews_per_month                   3827 non-null float64
    dtypes: float64(20), int64(14), object(58)
    memory usage: 4.1+ MB

