int main() {
	int a[5] = {2,20,3,4,5};
	int max_val = a[0];
	for(int i=1; i<5; i++) {
		int value = a[i];
		if(value > max_val){
			max_val = value;
		}
	}
	return max_val;
}
