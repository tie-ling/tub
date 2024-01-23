from cProfile import Profile
from pstats import SortKey, Stats
with Profile() as profile:
    print(f"{iscoprime(238213847,83274238547) = }")
    (
        Stats(profile)
        .strip_dirs()
        .sort_stats(SortKey.CALLS)
        .print_stats()
    )
