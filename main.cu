#include <iostream>
#include <numeric>

__global__ void check_prime_cuda(const long long unsigned *number, bool *is_prime) {
    const unsigned int i = blockIdx.x * blockDim.x + threadIdx.x + 2;

    if((*number) % i == 0)
        *is_prime = false;
}

__global__ void and_bools(const bool *in, bool *out) {
    unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;

    if (!in[i])
        *out = false;
}

bool check_prime(const long long unsigned number){
    unsigned long long root = (long long) sqrtl((long double)number),  *number_cuda;

    bool *is_prime = new bool(true);
    bool *results_cuda;

    cudaMalloc((void **) &number_cuda, sizeof(long long unsigned));
    cudaMalloc((void **) &results_cuda, sizeof(bool));

    cudaMemcpy(number_cuda, &number, sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(results_cuda, is_prime, sizeof(bool), cudaMemcpyHostToDevice);

    check_prime_cuda<<<1, root>>>(number_cuda, results_cuda);

    cudaMemcpy(is_prime, results_cuda, sizeof(bool), cudaMemcpyDeviceToHost);


    cudaFree(number_cuda);
    cudaFree(results_cuda);

    return *is_prime;
}

int main(int argc, char **argv) {
    long long unsigned number;

    if(argc < 2)
        throw std::exception("Argument required: Number to check");
    else
        number = strtoull(argv[1], nullptr, 10);

//    for(long long unsigned i = 0; i < number; i++)
//        check_prime(i);

    bool is_prime = check_prime(number);

    if(argc > 2 && strcmp(argv[2],"--quite") == 0)
        return is_prime;

    std::cout << number << " is" << (is_prime ? " ": " not ") << "prime\n";

    return 0;
}
