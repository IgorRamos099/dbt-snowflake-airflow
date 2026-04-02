with transform as (
select
    id,
    name,
    description,
    count(*) as qtd_developer
from 
    {{ ref('int_prepped_developer') }}
group by
    id,name,description
)
select * from transform