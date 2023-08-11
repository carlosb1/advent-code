use std::env;
use std::fs;

fn is_top_carry(top_carries: &Vec<u32>, compared_carry: u32) -> bool {
    top_carries.len() < 3 || top_carries.iter().any(|&v| v < compared_carry)
}
fn add_or_update_top_carry(top_carries: &Vec<u32>, add_carry: u32) -> Vec<u32> {
    let mut new_top_carries = top_carries.clone();
    new_top_carries.push(add_carry);
    new_top_carries.sort();
    new_top_carries.iter().rev().take(3).map(|&v| v).collect()
}

fn main() -> Result<(), String> {
    let args: Vec<String> = env::args().collect();
    let file_path = args.get(1).ok_or("It is necessary an argument")?;
    let contents =
        fs::read_to_string(file_path).map_err(|_| "it was not possible open the file")?;

    let mut current_carriers: Vec<u32> = Vec::new();
    let mut top_carries: Vec<u32> = Vec::new();
    for line in contents.lines() {
        if line.is_empty() {
            let sum_carries = current_carriers.iter().sum();

            if is_top_carry(&top_carries, sum_carries) {
                top_carries = add_or_update_top_carry(&top_carries, sum_carries);
            }
            current_carriers.clear();
        }
        if let Ok(number) = line.parse::<u32>() {
            current_carriers.push(number);
        }
    }
    println!("{:}", top_carries.iter().sum::<u32>());

    Ok(())
}
