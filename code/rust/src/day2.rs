use lazy_static::lazy_static;
use std::collections::HashMap;
use std::env;
use std::fs;

lazy_static! {
    static ref WEAK_GOOD_FOR: HashMap<&'static str, (&'static str, &'static str)> =
        HashMap::from([("A", ("B", "C")), ("C", ("A", "B")), ("B", ("C", "A"))]);
    static ref EXPECTED_RESULTS: HashMap<&'static str, FightResult> = HashMap::from([
        ("X", FightResult::Loss),
        ("Y", FightResult::Draw),
        ("Z", FightResult::Win)
    ]);
    static ref SCORES: HashMap<&'static str, u8> = HashMap::from([("A", 1), ("B", 2), ("C", 3)]);
}

fn score_result(result: &FightResult) -> u8 {
    match result {
        FightResult::Win => 6,
        FightResult::Draw => 3,
        FightResult::Loss => 0,
    }
}
#[derive(Debug)]
enum FightResult {
    Win,
    Draw,
    Loss,
}

fn translate(name_mov: &str) -> String {
    match name_mov {
        "A" => "Rock",
        "B" => "Paper",
        "C" => "Sciccors",
        _ => "Not exist",
    }
    .to_string()
}

fn calculate_your_movement(opponent_strategy: &str, expected_movement: &FightResult) -> String {
    let (weak, good) = *WEAK_GOOD_FOR
        .get(opponent_strategy)
        .expect("not find strategy");
    match *expected_movement {
        FightResult::Win => weak,
        FightResult::Draw => opponent_strategy,
        FightResult::Loss => good,
    }
    .to_string()
}

fn main() -> Result<(), String> {
    let args: Vec<String> = env::args().collect();
    let file_path = args.get(1).ok_or("It is necessary an argument")?;
    let contents =
        fs::read_to_string(file_path).map_err(|_| "it was not possible open the file")?;

    let mut results: Vec<(String, &FightResult)> = vec![];
    for line in contents.lines() {
        let (opponent_strategy, index_your_strategy) = line.split_at(2);
        let expected_result: &FightResult = EXPECTED_RESULTS
            .get(index_your_strategy.trim())
            .expect("it is not a correct predict result");
        let opponent_strategy = opponent_strategy.trim();

        let your_strategy = calculate_your_movement(opponent_strategy, expected_result);

        results.push((your_strategy, expected_result));
    }

    let score: u32 = results
        .iter()
        .map(|(strategy, result)| {
            (SCORES.get(strategy.trim()).unwrap() + score_result(result)) as u32
        })
        .sum();
    println!("{:}", score);
    Ok(())
}
