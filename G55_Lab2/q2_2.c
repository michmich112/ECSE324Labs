extern MAX_2(int x, int y);

int main() {
	int a[5] = {2,20,3,4,5};
	int max_val = a[0];
	for(int i=1; i<5; i++) {
		max_val = MAX_2(a[i],max_val);
	}
	return max_val;
}
