/**************************************************************************************
 *  Copyright (c) 2019- Gabriele Mencagli and Andrea Cardaci
 *  
 *  This file is part of StreamBenchmarks.
 *  
 *  StreamBenchmarks is free software dual licensed under the GNU LGPL or MIT License.
 *  You can redistribute it and/or modify it under the terms of the
 *    * GNU Lesser General Public License as published by
 *      the Free Software Foundation, either version 3 of the License, or
 *      (at your option) any later version
 *    OR
 *    * MIT License: https://github.com/ParaGroup/StreamBenchmarks/blob/master/LICENSE.MIT
 *  
 *  StreamBenchmarks is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *  You should have received a copy of the GNU Lesser General Public License and
 *  the MIT License along with WindFlow. If not, see <http://www.gnu.org/licenses/>
 *  and <http://opensource.org/licenses/MIT/>.
 **************************************************************************************
 */

#pragma once

#include<util/configuration.hpp>
#include<iostream>

namespace util {

template <typename Builder>
Builder setup(const std::string &name, const util::Configuration &configuration, Builder builder) {
    int parallelism_hint = configuration.get_tree()[name.c_str()].GetInt();
    auto chaining = configuration.get_tree()["chaining"].GetBool();

    std::cout << "  * " << name << ": " << parallelism_hint << std::endl;
    // std::cout << "NODE: " << name << " ("<< parallelism_hint << ")\n";

        return builder
            .withName(name)
            .withParallelism(parallelism_hint);
}

}
