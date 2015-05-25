require 'spec_helper'

describe Visualizer, :type => :class do

    describe '#visualize' do

        it 'should visualize json data' do

            json_data = '{"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_1.1-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_1.2-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_1.3-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_1.4-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_1.5-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_1.6-result.txt":{"memory_time":"0.839036226272583","matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_1.7-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_1.8-result.txt":{"memory_time":"0.8391544818878174","matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_2.1-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_2.2-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_2.3-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_2.4-result.txt":{"memory_time":"0.7312803268432617","matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_2.5-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_2.6-result.txt":{"memory_time":"0.7664897441864014","matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_2.7-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_2.8-result.txt":{"memory_time":"0.7578918933868408","matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_3.1-result.txt":{"memory_time":"0.7649586200714111","matches":[],"match_time":"83","total_time":"1432493925.4980142","match_count":"0"},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_3.2-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_3.3-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_3.4-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_3.5-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_3.6-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_combinations_3.7-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_deletions_1-result.txt":{"memory_time":"0.808598518371582","matches":[],"match_time":"83","total_time":"1432491800.868287","match_count":"0"},"../patscan-patterns/benchmark/results/ruby/benchmark_deletions_2-result.txt":{"memory_time":"0.9284543991088867","matches":[],"match_time":"83","total_time":"1432491851.2108316","match_count":"4"},"../patscan-patterns/benchmark/results/ruby/benchmark_deletions_3-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_deletions_4-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_deletions_5-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_deletions_6-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_deletions_7-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_deletions_8-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_deletions_9-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_insertions_1-result.txt":{"memory_time":"0.7363557815551758","matches":[],"match_time":"83","total_time":"1432492423.6727612","match_count":"0"},"../patscan-patterns/benchmark/results/ruby/benchmark_insertions_2-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_insertions_3-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_insertions_4-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_insertions_5-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_mismatches_1-result.txt":{"memory_time":"0.7255878448486328","matches":[],"match_time":"83","total_time":"1432492722.6713982","match_count":"0"},"../patscan-patterns/benchmark/results/ruby/benchmark_mismatches_2-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_mismatches_3-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_mismatches_4-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_mismatches_5-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_mismatches_6-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_mismatches_7-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_mismatches_8-result.txt":{"memory_time":"0.7543437480926514","matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_mismatches_9-result.txt":{"memory_time":"0.6516408920288086","matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/benchmark_range_1-result.txt":{"memory_time":"0.7863779067993164","matches":[],"match_time":"83","total_time":"1432494942.5169606","match_count":"6"},"../patscan-patterns/benchmark/results/ruby/benchmark_range_10-result.txt":{"memory_time":"0.7885711193084717","matches":[],"match_time":"83","total_time":"1432494942.3832722","match_count":"0"},"../patscan-patterns/benchmark/results/ruby/benchmark_range_2-result.txt":{"memory_time":"0.7600815296173096","matches":[],"match_time":"83","total_time":"1432494942.4490347","match_count":"14"},"../patscan-patterns/benchmark/results/ruby/benchmark_range_3-result.txt":{"memory_time":"0.749314546585083","matches":[],"match_time":"83","total_time":"1432494942.4490364","match_count":"9"},"../patscan-patterns/benchmark/results/ruby/benchmark_range_4-result.txt":{"memory_time":"0.7472333908081055","matches":[],"match_time":"83","total_time":"1432495092.4554636","match_count":"11"},"../patscan-patterns/benchmark/results/ruby/benchmark_range_5-result.txt":{"memory_time":"0.813939094543457","matches":[],"match_time":"83","total_time":"1432495092.581666","match_count":"1"},"../patscan-patterns/benchmark/results/ruby/benchmark_range_6-result.txt":{"memory_time":"0.810976505279541","matches":[],"match_time":"83","total_time":"1432495092.4262602","match_count":"0"},"../patscan-patterns/benchmark/results/ruby/benchmark_range_7-result.txt":{"memory_time":"0.7635176181793213","matches":[],"match_time":"83","total_time":"1432495092.3792002","match_count":"0"},"../patscan-patterns/benchmark/results/ruby/benchmark_range_8-result.txt":{"memory_time":"0.7749595642089844","matches":[],"match_time":"83","total_time":"1432495242.447219","match_count":"0"},"../patscan-patterns/benchmark/results/ruby/benchmark_range_9-result.txt":{"memory_time":"0.7788262367248535","matches":[],"match_time":"83","total_time":"1432495242.444511","match_count":"0"},"../patscan-patterns/benchmark/results/ruby/benchmark_sequence_1-result.txt":{"memory_time":"0.8084206581115723","matches":[],"match_time":"83","total_time":"1432495242.7105863","match_count":"106233"},"../patscan-patterns/benchmark/results/ruby/benchmark_sequence_2-result.txt":{"memory_time":"0.7739043235778809","matches":[],"match_time":"83","total_time":"1432495242.4495935","match_count":"368"},"../patscan-patterns/benchmark/results/ruby/benchmark_sequence_3-result.txt":{"memory_time":"0.8033909797668457","matches":[],"match_time":"83","total_time":"1432495392.438684","match_count":"2"},"../patscan-patterns/benchmark/results/ruby/benchmark_sequence_4-result.txt":{"memory_time":"0.7459893226623535","matches":[],"match_time":"83","total_time":"1432495392.3590777","match_count":"0"},"../patscan-patterns/benchmark/results/ruby/benchmark_sequence_5-result.txt":{"memory_time":"0.7692337036132812","matches":[],"match_time":"83","total_time":"1432495392.3551545","match_count":"0"},"../patscan-patterns/benchmark/results/ruby/benchmark_sequence_6-result.txt":{"memory_time":"0.8364620208740234","matches":[],"match_time":"83","total_time":"1432495392.4467995","match_count":"0"},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_1.1-result.txt":{"memory_time":"0.8026285171508789","matches":[],"match_time":"83","total_time":"1432494156.7863684","match_count":"206639"},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_1.2-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_1.3-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_1.4-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_1.5-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_1.6-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_1.7-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_2.1-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_2.2-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_2.3-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_2.4-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_2.5-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_2.6-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_2.7-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_3.1-result.txt":{"memory_time":"0.7571825981140137","matches":[],"match_time":"83","total_time":"1432494662.6004636","match_count":"4215"},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_3.2-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_3.3-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_3.4-result.txt":{"memory_time":"0.8040285110473633","matches":[],"match_time":"83","total_time":"1432494904.9548633","match_count":"9257"},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_3.5-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_3.6-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_combinations_3.7-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_deletions_1-result.txt":{"memory_time":"0.759124755859375","matches":[],"match_time":"83","total_time":"1432492098.1133358","match_count":"10744"},"../patscan-patterns/benchmark/results/ruby/small_benchmark_deletions_2-result.txt":{"memory_time":"0.777245283126831","matches":[],"match_time":"83","total_time":"1432492119.3519893","match_count":"137987"},"../patscan-patterns/benchmark/results/ruby/small_benchmark_deletions_3-result.txt":{"memory_time":"0.7336444854736328","matches":[],"match_time":"83","total_time":"1432492147.153714","match_count":"827845"},"../patscan-patterns/benchmark/results/ruby/small_benchmark_deletions_4-result.txt":{"memory_time":"0.7797596454620361","matches":[],"match_time":"83","total_time":"1432492307.8531168","match_count":"2596254"},"../patscan-patterns/benchmark/results/ruby/small_benchmark_deletions_5-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_deletions_6-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_insertions_1-result.txt":{"memory_time":"0.7726655006408691","matches":[],"match_time":"83","total_time":"1432492559.3873513","match_count":"6883"},"../patscan-patterns/benchmark/results/ruby/small_benchmark_insertions_2-result.txt":{"memory_time":"0.7505125999450684","matches":[],"match_time":"83","total_time":"1432492615.6948419","match_count":"22448"},"../patscan-patterns/benchmark/results/ruby/small_benchmark_insertions_3-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_insertions_4-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_mismatches_1-result.txt":{"memory_time":"0.7190103530883789","matches":[],"match_time":"83","total_time":"1432493001.457319","match_count":"12819"},"../patscan-patterns/benchmark/results/ruby/small_benchmark_mismatches_2-result.txt":{"memory_time":"0.7541604042053223","matches":[],"match_time":"83","total_time":"1432493208.640673","match_count":"122939"},"../patscan-patterns/benchmark/results/ruby/small_benchmark_mismatches_4-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/small_benchmark_mismatches_5-result.txt":{"memory_time":0,"matches":[],"match_time":"83","total_time":0,"match_count":0},"../patscan-patterns/benchmark/results/ruby/tiny_benchmark_deletions_1-result.txt":{"memory_time":"0.8010520935058594","matches":[],"match_time":"83","total_time":"1432492250.4504282","match_count":"2095795"},"../patscan-patterns/benchmark/results/ruby/tiny_benchmark_insertions_4-result.txt":{"memory_time":"0.8161306381225586","matches":[],"match_time":"83","total_time":"1432492704.256018","match_count":"357149"},"../patscan-patterns/benchmark/results/ruby/tiny_benchmark_mismatches_1-result.txt":{"memory_time":"0.7336037158966064","matches":[],"match_time":"83","total_time":"1432493155.2320979","match_count":"1590504"}}'

            visualizer = Visualizer.new JSON.parse(json_data)
            visualizer.visualzie
        end
    end
end
